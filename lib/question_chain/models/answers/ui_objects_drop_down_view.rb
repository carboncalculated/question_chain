module Answers
  class UiObjectsDropDownView < Answers::UiObjectView
    
    def prompt
      ui_object.prompt
    end
        
    def options
      if answer_params
        ui_object.drop_down_options.map{|option| option.merge!(:selected => option["value"].to_s == value.to_s)}
      else
        ui_object.drop_down_options
      end
    end
  end
end