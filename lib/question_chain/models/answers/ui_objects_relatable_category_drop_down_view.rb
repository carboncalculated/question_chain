module Answers
  class UiObjectsRelatableCategoryDropDownView < Answers::UiObjectView
    
    def prompt
      ui_object.prompt
    end
    
    # @return [Array<Hash<value => value, name => name>>]
    def options
      if answer_params
        ui_object.options.map{|option| option.merge!(:selected => option["value"].to_s == value.to_s)}
      else
        ui_object.options
      end
    end
    
  end
end