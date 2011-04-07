class User
  include Mongoid::Document
  
  #== Fields
  field :name, :type => String
  
  def full_name
    name
  end
  
end