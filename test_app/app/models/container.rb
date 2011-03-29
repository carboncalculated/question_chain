class Container
  include MongoMapper::Document
  
  # == Keys
  key :name, String
  
  # == Associations
  has_many :flights

end