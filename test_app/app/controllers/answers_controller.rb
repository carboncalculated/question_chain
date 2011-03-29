class AnswersController < ApplicationController
  inherit_resources
  include Canable::Enforcers
  belongs_to :container, :polymorphic => true
  include QuestionChain::Answers
    
  private
  # I will not go into however this is required but not from the include
  def collection_path
    polymorphic_path(@contexts[0..-1] << @context.to_sym)  
  end
end

