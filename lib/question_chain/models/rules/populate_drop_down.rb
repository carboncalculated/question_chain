module Rules
  class PopulateDropDown < Rule
    
    # == Keys
    field :ui_object_attribute_check, :type => Hash, :default => nil
      
    def fire!(value = nil, ui_objects_hash = {})
      # does not matter what the value is in this instance
      # it is used to get opions for the drop_down_target
    end
    
    def drop_down_target_id
      ui_object.drop_down_target_id
    end
    
    # ask the parent document to get the options
    def get_options(object_ids = [])
      options = []
      ui_object.get_target_drop_down_options(object_ids).each_pair do |key ,value|
        options << {:name => value, :value => key}
      end
      options.sort_by{|option| option[:name]}
    end
    
    def self.attributes_for_api
      %w(id fire_value _type ui_object_id drop_down_target_id ui_object_attribute_check negate_value)
    end
    
  end
end