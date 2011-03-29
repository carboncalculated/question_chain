module Answers
  class UiObjectsCheckBoxView < Answers::UiObjectView
    
    def value
      super || default_value
    end
    
    def checked
      if value 
        !value.nil?
      else 
        ui_object.ui_attributes[:checked]
      end
    end

  end
end