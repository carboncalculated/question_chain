module Rules
  class ValueChange < Rule
    
    # == Keys
    field :change_value, :type => String
    
    # == Validations
    validates_presence_of :change_value
    validates_presence_of :affecting_ui_object
    
    # == Association
    belongs_to :affecting_ui_object, :class_name => "UiObject"
    
    def fire!(value = nil, ui_objects_hash = {})
      # does not matter what the value is in this instance
      # it is used to get opions for the drop_down_target
    end
            
    def self.attributes_for_api
      %w(id fire_value _type ui_object_id affecting_ui_object_id negate_value)
    end

  end
end