module Answers
  class UiObjectsObjectSearchView < Answers::UiObjectView
    
    def search_name
      "answer[search_#{name}]"
    end
    
    def search_id
      "search_#{dom_id()}"
    end
    
    def search_value
      if answer_params
        answer_params["search_answer"][ui_object_name]
      end
    end
    
    def value
      super || default_value
    end   
  end
end