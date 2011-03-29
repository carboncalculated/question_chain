class RelatableCategoryFilter 
  include MongoMapper::Document
  include MongoMapper::Serialize
  
  # == Keys
  key :filters, Array
  key :ui_group_id, ObjectId
  
  # == Associations
  belongs_to :ui_group
  
  def self.attributes_for_api
    %w(id filters ui_group_id)
  end
end