module Rules
  class ValueChange < Rule
    
    # == Keys
    key :affecting_ui_object_id, ObjectId
    key :change_value, String
    
    # == Validations
    validates_presence_of :affecting_ui_object_id
    validates_presence_of :change_value
    
    def fire!(value = nil, ui_objects_hash = {})
      # does not matter what the value is in this instance
      # it is used to get opions for the drop_down_target
    end
            
    def self.attributes_for_api
      %w(id fire_value _type ui_object_id affecting_ui_object_id negate_value)
    end

  end
end