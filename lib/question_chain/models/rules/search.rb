module Rules
  class Search < Rule
      
    def fire!(value = nil, ui_objects_hash = {})
      # does not matter what the value is in this instance
      # it is used to get opions for the drop_down_target
    end
        
    # ask the parent document to get the options
    def get_options(filter, relatable_category_names = [])
      ui_object.ui_options(filter, relatable_category_names)
    end
    
    def self.attributes_for_api
      %w(id fire_value _type ui_object_id negate_value)
    end

  end
end