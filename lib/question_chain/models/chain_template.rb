class ChainTemplate 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Transitions
  
  # == Keys
  field :context, :type => Hash # [Hash<content => [Array<MongoIds>]>]
  field :for_resource, :type => String
  field :parent_resource, :type => String
  field :active_at, :type => Time
  field :state, :type => String, :default => "pending"
  
  # == State Machine
  state_machine :initial => :pending do
    state :pending
    state :active

    event :activate do
      transitions :to => :active, :from => [:pending],  :on_transition => :set_active_at
    end
    
    event :deactivate do
      transitions :to => :pending, :from => [:active]
    end
  end
  
  # == Indexes
  index :for_resource
  
  # == Validations
  validates_presence_of :for_resource
  validates_presence_of :context
  
  def state
    read_attribute(:model_state)
  end
  
  def state=(state)
    write_attribute(:model_state, state)
  end
  
  def self.attributes_for_api
    %w(id name for_resource account_id parent_resource)
  end
  
  protected
  def set_active_at
    self.active_at = Time.now
    self.save!
  end
end