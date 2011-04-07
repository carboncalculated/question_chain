class Container
  include Mongoid::Document
  
  # == Fields
  field :name, :type => String
  
  # == Associations
  has_many :flights

end