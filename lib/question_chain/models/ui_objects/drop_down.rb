module UiObjects
  class DropDown < UiObject
    
    # == Fields
    field :drop_down_options, :type => Array, :default => []
    field :prompt, :type => String
    field :max_options, :type => Integer, :default => 20
    field :populate, :type => Boolean, :default => true
    field :order, :type =>String
    field :filter, :type => Array, :default => []
    
    # legacy for old options
    def drop_down_options
      ops = read_attribute(:drop_down_options)
      if ops && ops.empty?
        self[:options]
      else
        ops
      end
    end
    
    def self.attributes_for_api
      %w(id name _type populate label order filter description default_value ui_attributes drop_down_options prompt max_options rules extra_info css_classes)
    end

  end
end