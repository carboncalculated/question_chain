class Flight
  include Mongoid::Document
  include QuestionChain::Answerable

  # == Assocations
  belongs_to :container
  
  self._extra_keyword_methods = [:milk, :beans]
  
  def object_reference_name
    "flight"
  end
  
  def milk
    "black rebel"
  end
  
  def beans
    "motocycle"
  end
end