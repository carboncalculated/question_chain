class Rule
  include Mongoid::Document
  include Mongoid::Serialize
  
  # == Keys
  field :fire_value, :type => String
  field :negate_value, :type => Boolean, :default => false
  
  # == Assocations
  embedded_in :ui_object
    
  def ui_object_id
    ui_object.id
  end
  
  # have to have this here to declear all subclass not being used?
  def self.attributes_for_api
    %w(id fire_value _type ui_object_id negate_value)
  end
  
  # this will manipulate the question hash with the updated
  # attributes for the affecting ui objects that are 
  # attached to this rule
  #
  # @return [TrueClass] when the fire! is actually doing that
  def fire!(value, question_hash = {})
    raise NotImplementedError, "Need to set the fire! method"
  end
end