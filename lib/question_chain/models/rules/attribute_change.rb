module Rules
  class AttributeChange < Rule
    
    # {:id => {:atttibute_name => "new_state"}, :id => {:atttibute_name => "new_state"}}
    field :affecting_ui_objects, :type => Hash
    field :compare_text_value, :type => Boolean, :default => false
    
    def self.attributes_for_api
      %w(id fire_value _type affecting_ui_objects ui_object_id negate_value compare_text_value)
    end
    
    # Checks to determine the value and the fire_value if cool 
    # then the ui objects are updated depending on the affecting values
    #
    # @param [UiObject] ui_object the ui object that this rul is observing
    # @param [String] value the value that the ui_object has
    # @param [Array<Hash>] ui_objects
    def fire!(value, ui_objects)
      if negate_value ? value != self.fire_value : value == self.fire_value
        affecting_ui_objects.each_pair do |key, value|
          if ui_object = ui_objects.detect{|ui| ui["id"] == key}
            ui_object["ui_attributes"].merge!(value)
          end
        end
      end
    end
    
  end
end