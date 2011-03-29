module UiObjects
  class DropDown < UiObject
    
    # == keys
    key :options, Array
    key :prompt, String
    key :max_options, Integer, :default => 20
    key :populate, Boolean, :default => true
    key :order, String
    key :filter, Set

    def self.attributes_for_api
      %w(id name _type populate label order filter description default_value ui_attributes options prompt max_options rules extra_info css_classes)
    end

  end
end