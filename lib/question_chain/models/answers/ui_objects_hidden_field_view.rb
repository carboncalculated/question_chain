module Answers
  class UiObjectsHiddenFieldView < Answers::UiObjectView
    
    def value
      super || default_value
    end   
  end
end