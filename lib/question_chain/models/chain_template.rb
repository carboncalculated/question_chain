class ChainTemplate 
  include MongoMapper::Document
  include MongoMapper::StateMachine
  
  # == Keys
  key :context, Hash # [Hash<content => [Array<MongoIds>]>]
  key :account_id, ObjectId # used to override any specific question essentially
  key :for_resource, String
  key :parent_resource, String
  key :active_at, Time
  
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
  ensure_index :for_resource
  
  # == Validations
  validates_presence_of :for_resource
  validates_presence_of :context
  validates_true_for :context, :logic => Proc.new{ !context.empty?}
  
  def self.attributes_for_api
    %w(id name for_resource account_id parent_resource)
  end
  
  protected
  def set_active_at
    self.active_at = Time.now
    self.save!
  end
end