module UiObjects
  class ObjectSearch < UiObject
    
    # == keys
    key :object_name, String
    key :max_options, Integer, :default => 20
    key :prompt, String
    key :attribute_for_value, String, :default => "id"
    key :attribute_for_display, String, :default => "identifier"
    
    # == Validations
    validates_presence_of :object_name
    
    # == Hooks
    after_create :add_default_rule
    
    # == Attrs
    attr_accessor_with_default :default_rule, true
    
    def self.attributes_for_api
      %w(id name _type label position description rules ui_attributes prompt max_options object_name extra_info css_classes)
    end
    
    def options(filter, relatable_category_names = [])
      @options ||= get_options(object_name, filter || "", relatable_category_names)
    end
    
    protected
    def get_options(object_name, filter, relatable_category_names)
      response = QuestionChain::calculated_session.generic_objects_for_object_template_with_filter(object_name, filter, :relatable_category_values => relatable_category_names, :per_page => per_page)
      response.generic_objects.map do |obj| 
        {:value => obj.send(self.attribute_for_value), :name => obj.identifier}
      end
    end
    
    def add_default_rule
      if default_rule
        self.rules << Rules::Search.new
        self.save
      end
    end

  end
end