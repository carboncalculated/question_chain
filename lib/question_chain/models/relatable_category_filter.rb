class RelatableCategoryFilter 
  include Mongoid::Document
  include Mongoid::Serialize
  
  # == Fields
  field :filters, :type => Array, :default => []
  
  # == Associations
  belongs_to :ui_group, :index => true
  
  def self.attributes_for_api
    %w(id filters ui_group_id)
  end
end