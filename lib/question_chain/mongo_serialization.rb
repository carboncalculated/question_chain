module MongoMapper
  module Serialize
    extend ActiveSupport::Concern
    
    included do
      def self.attributes_for_api; []; end
      def self.attributes_for_columns;[]; end
      def self.columns
        self.attributes_for_columns.map{|c| {:name => c}}
      end
    end
    
    module InstanceMethods
      # this is how we serialize man
      def attributes_for_api_resource
        result = {self.api_name => {}}
        self.class.attributes_for_api.each do |key|
          attribute = self.send(key)
          if attribute.is_a?(Array) || attribute.is_a?(Set)
            attribute.map! do |attr|
              attr.respond_to?(:attributes_for_api_resources) ? attr.attributes_for_api_resources : attr
            end
            attribute = attribute.to_a
          end
          if attribute.nil? || attribute.is_a?(Array) || attribute.is_a?(Set)
            result[self.api_name][key] = attribute
          else
            result[self.api_name][key] = (attribute.is_a?(BSON::ObjectId)) ? attribute.to_s : attribute
          end
        end
        result
      end

      def attributes_for_api_resources
        result = {}
        self.class.attributes_for_api.each do |key|
          attribute = self.send(key)
          if attribute.is_a?(Array) || attribute.is_a?(Set)
            attribute.map! do |attr|
              attr.respond_to?(:attributes_for_api_resources) ? attr.attributes_for_api_resources : attr
            end
            attribute = attribute.to_a
          end
          if attribute.nil?
            result[key] = attribute
          else
            result[key] = (attribute.is_a?(BSON::ObjectId)) ? attribute.to_s : attribute
          end
        end
        result
      end
    
      def api_name
        self.class.name.demodulize.underscore
      end
      
      def to_json
        attributes_for_api_resource.to_json
      end
    end
  end
end