require "observer"
class UiObject
  include ::Observable
  include MongoMapper::Document
  include MongoMapper::Serialize

  # == Keys
  key :_type, String
  key :name, String
  key :label, String
  key :description, String
  key :default_value, String
  key :ui_attributes, Hash
  key :ui_group_id, ObjectId
  key :position, Integer
  key :extra_info, String
  key :per_page, Integer, :default => 50
  key :css_classes, Array, :default => ["single"]
  timestamps!
  
  # == Indexes
  ensure_index :label
  ensure_index "rules.name"
  
  # == Attrs
  attr_accessor :value
  class_attribute :default_values
  
  # Class set values  
  self.default_values = {:visible => true, :enabled => true}

  # == Validations
  validates_presence_of :ui_group_id
  validates_presence_of :label
  validates_presence_of :ui_attributes
  validate :valid_ui_attributes
  validates_associated :rules
  
  # == Associations
  belongs_to :ui_group
  many :rules
  
  # == Hooks
  before_save :add_rule_observers!
  before_validation :set_default_attributes, :on => :create
  
  def self.attributes_for_api
    %w(id name _type label description default_value ui_attributes ui_group_id rules extra_info css_classes)
  end
  
  # == need as added a little late in the day basically
  def per_page
    read_attribute(:per_page) || 50
  end
    
  def initialize(*args)
    super
    add_rule_observers!
  end
 
  # fires the rules that are attached the ui object
  def change_value!(ui_objects = [])
    if ui_object = ui_objects.detect{|ui| ui["id"] == self.id.to_s}
      value = ui_object["ui_attributes"] && ui_object["ui_attributes"]["value"] || ""
      @observer_state = true
      notify_observers(value, ui_objects)
    end
  end
      
  def visible?
    ui_attributes[:visible]
  end
  
  def enabled?
    ui_attributes[:enabled]
  end

  protected  
  def set_default_attributes
    self.ui_attributes = self.class.default_values.merge(:value => self.default_value || "").merge(self.ui_attributes || {})
  end
  
  # Adding the obervers so we can fire rules
  def add_rule_observers!
    rules.each do |rule|
      self.add_observer(rule, :fire!)
    end
  end
  
  def valid_ui_attributes
    errors.add(:ui_attributes, "") if ui_attributes.empty?
  end

end
