module Answers
  class UiObjectsTextFieldView < Answers::UiObjectView
    
    def value
      super || default_value
    end   
  end
end