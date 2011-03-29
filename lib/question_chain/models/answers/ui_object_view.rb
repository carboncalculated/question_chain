module Answers
  class UiObjectView < MustacheRails
    
    def dom_id
      "ui_object_#{ui_object.id}"
    end
    
    def input_id
      "ui_input_#{ui_object.id}"
    end
    
    def extra_info
      ui_object.try(:extra_info)
    end
    
    def css_classes
      ui_object.css_classes.join(" ")
    end
    
    def has_extra_info
      !extra_info.blank?
    end
    
    def label
      ui_object.label
    end
    
    def value
      answer_params[ui_object_name] if answer_params
    end
    
    def ui_object_name
      ui_object.name
    end
    
    def name
      "answer[#{ui_object.name}]"
    end
    
    def default_value
      ui_object.default_value
    end
    
    def default_styles
      default_styles = ""
      ui_object.ui_attributes.each_pair do |key, value|
        if key.to_s == "visible" && value == "false"
          default_styles << "display:none;visibility:hidden;"
        end
      end
      default_styles
    end
    
    def disabled
      ui_object.ui_attributes["disable"] == "true"
    end
    
    protected
    def ui_object
      @ui_object ||= context[:_ui_object]
    end
    
    def answer_params
      @answer_params ||= context[:_answer_params]
    end
  end
end