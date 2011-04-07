module QuestionChain
  module Answerable
    extend ActiveSupport::Concern
    include Mongoid::Serialize
  
    included do
      include Mongoid::Search
      
      field :result, :type => Hash
      field :answer_params, :type => Hash
      field :answer_json, :type => String
      field :reference, :type => String
      field :stored_identifier, :type => String
      field :stored_variable_input, :type => String
      field :created_by, :type => String
      field :_extra_keywords, :type => Array, :default => []
    
      cattr_accessor :_extra_keyword_methods
      before_save :add_stored_identifier
      before_save :add_extra_keywords
      before_save :cache_attributes
      
      # == Search
      search_in :reference, :created_by, :stored_variable_input, :stored_identifier, :_extra_keywords => :to_s
      
      # == Indexes
      index :reference
      index :stored_identifier
      index :stored_variable_input
      
      # == Validations
      validates_presence_of :question_id
      validates_presence_of :answer_params
      validates_presence_of :result
      validates_presence_of :user
      
      # == Associations
      belongs_to :user
      belongs_to :question
      
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
        write_attribute(:created_by, user.full_name)
        write_attribute(:stored_variable_input, variable_input)
      end
    end
  end
end