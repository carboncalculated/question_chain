class Question
  include MongoMapper::Document
  include MongoMapper::Serialize
  
  # == Keys
  key :name, String
  key :label, String
  key :_type, String
  key :description, String
  key :calculator_id, ObjectId
  key :computation_id, ObjectId
  timestamps!
  
  # == Indexes
  ensure_index :names
  ensure_index :label
    
  # == Validations
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # == Associations
  many :ui_groups, :order => :position.asc, :dependent => :destroy
  
  # == Hooks
  def self.attributes_for_api
    %w(id name description computation_id ui_groups label calculator_id)
  end
  
  def to_json
    attributes_for_api_resource.to_json
  end
  
  def to_hash
    Hashie::Mash.new(attributes_for_api_resources)
  end
end