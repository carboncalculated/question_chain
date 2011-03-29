# holds a group of ui objects basically
# keep simple to start of with 
class UiGroup
  include MongoMapper::Document
  include MongoMapper::Serialize
  
  # == Keys
  key :name, String
  key :description, String
  key :label, String
  key :parent_id, ObjectId
  key :parent_ids, Array
  key :question_id, ObjectId
  key :ui_attributes, Hash
  key :css_classes, Array, :default => ["single"]
  timestamps!
  
  # == Indexes
  ensure_index :parent_ids
  ensure_index :name
  
  # == Validations
  validates_presence_of :name
  validates_presence_of :label
  validates_presence_of :question_id
  
  # == Associations
  belongs_to :parent
  belongs_to :question
  many :ui_objects, :order => :position.asc
  many :object_searches, :class_name => "UiObjects::ObjectSearch"
  many :text_fields, :class_name => "UiObjects::TextField"
  many :drop_downs, :class_name => "UiObjects::DropDown"
  many :checkboxes, :class_name => "UiObjects::CheckBox"
  one :object_reference_drop_down, :class_name => "UiObjects::ObjectReferenceDropDown"
  many :relatable_category_drop_downs, :class_name => "UiObjects::RelatableCategoryDropDown"  
  many :hidden_fields, :class_name => "UiObjects::HiddenField"  
  many :children, :class_name => 'UiGroup', :foreign_key => 'parent_id'
  one :relatable_category_filter, :class_name => "RelatableCategoryFilter"
  
  # thats right only ever one object_reference in a ui_group
  # its a constraint we just need
  one :object_reference_drop_down, :class_name => "UiObjects::ObjectReferenceDropDown"

  # == hooks
  before_save :set_parents
  
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
  
  protected
  def set_parents
    self.parent_ids = (parent.parent_ids || []) << parent_id if parent?
  end
end