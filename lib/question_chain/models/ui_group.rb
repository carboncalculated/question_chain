# holds a group of ui objects basically
# keep simple to start of with 
class UiGroup
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Serialize
  
  # == Fields
  field :name, :type => String
  field :description, :type => String
  field :label, :type => String
  field :ui_attributes, :type => Hash
  field :css_classes, :type => Array, :default => ["single"]

  # == Indexes
  index :name
  
  # == Validations
  validates_presence_of :name
  validates_presence_of :label
  validates_presence_of :question_id
  
  # == Associations
  belongs_to :parent
  belongs_to :question
  
  has_many :ui_objects, :order => :position.asc
  has_many :object_searches, :class_name => "UiObjects::ObjectSearch"
  has_many :text_fields, :class_name => "UiObjects::TextField"
  has_many :drop_downs, :class_name => "UiObjects::DropDown"
  has_many :checkboxes, :class_name => "UiObjects::CheckBox"
  has_one :object_reference_drop_down, :class_name => "UiObjects::ObjectReferenceDropDown"
  has_many :relatable_category_drop_downs, :class_name => "UiObjects::RelatableCategoryDropDown"  
  has_many :hidden_fields, :class_name => "UiObjects::HiddenField"  
  has_many :children, :class_name => 'UiGroup', :foreign_key => 'parent_id'
  has_one :relatable_category_filter, :class_name => "RelatableCategoryFilter"
  
  def self.attributes_for_api
    %w(id name label question_id relatable_category_filter ui_objects ui_attributes default_styles css_classes)
  end
  
  # this should go into the mustache view basically
  def default_styles
    default_styles = ""
    self.ui_attributes.each_pair do |key, value|
      if key.to_s == "visible" && value == false
        default_styles << "display:none;visibility:hidden;"
      end
    end
    default_styles
  end
  
  def css_classes
    read_attribute(:css_classes).join(" ")
  end
end