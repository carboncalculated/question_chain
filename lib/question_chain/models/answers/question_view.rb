module Answers
  class QuestionView < MustacheRails
    
    def name
      question.name
    end
    
    def label
      question.label
    end
    
    def description
      question.description
    end
    
    private
    def question
      @question ||= context[:_question]
    end
  end
end