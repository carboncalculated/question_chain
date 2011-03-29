class Flight
  include MongoMapper::Document
  include QuestionChain::Answerable
  
  key :container_id, ObjectId
  
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