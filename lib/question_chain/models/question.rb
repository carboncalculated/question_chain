class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Serialize
  
  # == Fields
  field :name, :type => String
  field :label, :type => String
  field :description, :type => String
  
  # == Indexes
  index :name
  index :label
    
  # == Validations
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # == Associations
  has_many :ui_groups, :order => :position.asc, :dependent => :destroy, :index => true
  belongs_to :calculator, :index => true
  belongs_to :computation, :index => true
  
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