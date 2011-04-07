 class UiObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Serialize

  # == Fields
  field :name, :type => String
  field :label, :type => String
  field :description, :type => String
  field :default_value, :type => String
  field :ui_attributes, :type => Hash
  field :position, :type => Integer
  field :extra_info, :type => String
  field :per_page, :type => Integer, :default => 50
  field :css_classes, :type => Array, :default => ["single"]
  
  # == Indexes
  index :label
  index "rules.name"
  
  # == Attrs
  attr_accessor :value
  class_inheritable_accessor :default_values
  
  # Class set values  
  self.default_values = {:visible => true, :enabled => true}

  # == Validations
  validates_presence_of :ui_group_id
  validates_presence_of :label
  validates_presence_of :ui_attributes
  # validates_true_for :ui_attributes, :logic => Proc.new{
  #   !ui_attributes.empty?
  # }
  validates_associated :rules
  
  # == Associations
  belongs_to :ui_group
  embeds_many :rules
  
  # == Hooks
  before_validation :set_default_attributes, :on => :create
  
  def self.attributes_for_api
    %w(id name _type label description default_value ui_attributes ui_group_id rules extra_info css_classes)
  end
  
  # == need as added a little late in the day basically
  def per_page
    read_attribute(:per_page) || 50
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

end