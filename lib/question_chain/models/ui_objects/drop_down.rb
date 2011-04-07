module UiObjects
  class DropDown < UiObject
    
    # == Fields
    field :drop_down_options, :type => Array
    field :prompt, :type => String
    field :max_options, :type => Integer, :default => 20
    field :populate, :type => Boolean, :default => true
    field :order, :type =>String
    field :filter, :type => Array

    def self.attributes_for_api
      %w(id name _type populate label order filter description default_value ui_attributes drop_down_options prompt max_options rules extra_info css_classes)
    end

  end
end