module UiObjects
  class CheckBox < UiObject
    
    # == Added defaults
    self.default_values = self.default_values.merge!(:checked => false)
    
  end
end
