module QuestionChain
  module Answerable
    extend ActiveSupport::Concern
    include MongoMapper::Serialize
    
  
    included do
      key :question_id, ObjectId
      key :result, Hash
      key :answer_params, Hash
      key :answer_json, String
      key :user_id, ObjectId
      key :reference, String
      key :stored_identifier, String
      key :stored_variable_input, String
      key :created_by, String
      key :_extra_keywords, Array
      timestamps!
    
      cattr_accessor :_extra_keyword_methods
      before_save :add_stored_identifier
      before_save :add_extra_keywords
      before_save :cache_attributes
      
      # == Search
      include Hunt
      searches :reference, :created_by, :stored_variable_input, :stored_identifier, :_extra_keywords
      ensure_index :'searches.default'
      
      # == Indexes
      ensure_index :reference
      ensure_index :stored_identifier
      ensure_index :stored_variable_input
      
      # == Validations
      validates_presence_of :question_id
      validates_presence_of :answer_params
      validates_presence_of :result
      validates_presence_of :user
      validate :valid_answer_params
      validate :valid_result
      
      # == Associations
      belongs_to :user
      
      # == attr Protected
      attr_protected :user_id
      
    end
        
    module InstanceMethods
      def add_extra_keywords
        unless (self.class._extra_keyword_methods || []).empty?
          self.class._extra_keyword_methods.each do |method|
           self._extra_keywords << self.send(method)
          end
        end
      end
          
      def object_reference_characteristics(object_reference = self.object_reference)
        object_reference["characteristics"]
      end
      
      def object_references
        result["object_references"]
      end

      def object_reference(object_reference_id = self.object_reference_id)
        result["object_references"] && result["object_references"][object_reference_id]
      end

      def object_reference_id(object_reference_name = self.object_reference_name)
        answer_params[object_reference_name]
      end
      
      def object_reference_name
        # should be set in the answerable if want to use
      end
      
      def variable_input
        # should be set in the answerable if you want to use this
      end
      
      # you should set this to be what stored identifier you 
      # wish to have if you use more then 1 object in 
      # your calculation
      def _identifier
        idents = []
        object_references.each_pair do |key, value|
          idents << value["identifier"]
        end
        idents.join(" ")
      end
    
      def identifier
        _identifier == read_attribute(:stored_identifier) ? read_attribute(:stored_identifier) : _identifier
      end
    
      def co2
        (result["calculations"]["co2"]["value"] || 0).to_f
      end
    
      def ch4
        (result["calculations"]["ch4"]["value"] || 0).to_f
      end
    
      def n2o
        (result["calculations"]["n2o"]["value"]|| 0).to_f
      end
      
      def co2e
        (result["calculations"]["co2e"]["value"] || 0).to_f
      end
          
      private
      def add_stored_identifier
        self.stored_identifier = self.identifier
      end
      
      def cache_attributes
        write_attribute(:created_by, user.full_name) if user && user.respond_to?(:full_name)
        write_attribute(:stored_variable_input, variable_input)
      end
      
      def valid_answer_params
        errors.add(:answer_params, "") if answer_params.empty?
      end
      
      def valid_result
        errors.add(:result, "") if result.empty?
      end
    end
    
  end
end