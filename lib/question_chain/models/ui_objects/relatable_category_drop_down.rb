module UiObjects
  class RelatableCategoryDropDown < UiObject
    
    # == Keys
    key :related_attribute, String
    key :object_name, String
    key :filters, Set
    key :order, String
    key :prompt, String
    key :max_options, Integer, :default => 20
    key :drop_down_target_id, ObjectId
    key :drop_down_target_is_relatable, Boolean, :default => false
    key :populate, Boolean, :default => true
    key :attribute_for_value, String, :default => "id"
    key :attribute_for_display, String, :default => "label"
    key :external, Boolean, :default => true
    
    # == Indexes
    ensure_index :filters
    ensure_index :object_name
    ensure_index :related_attribute
    
    # == Validations
    validates_presence_of :related_attribute
    validates_presence_of :object_name
    
    # == Associations
    belongs_to :drop_down_target, :class_name => "UiObject", :foreign_key => "drop_down_target_id"
        
    # == Hooks
    after_create :add_default_rule
    
    # == Attrs
    attr_accessor_with_default :default_rule, true
    
    def options
      return [] if !populate
      @options ||= relatable_categories.select{|obj| (filters.empty? || (!filters.empty? && filters.include?(obj.id.to_s)))}.map do |obj|
        {:value => obj.id, :name => obj.name}
      end.sort_by{|option| option[:name]}
    end
    
    def get_target_drop_down_options(relatable_category_ids = [])
      if drop_down_target_is_relatable
        id = relatable_category_ids.shift
        QuestionChain.calculated_session.related_categories_from_relatable_category(id.to_s, drop_down_target.related_attribute, {:relatable_category_ids => relatable_category_ids, :per_page => per_page})
      else
        QuestionChain.calculated_session.related_objects_from_relatable_categories(self.object_name, relatable_category_ids, :per_page => per_page)
      end
    end
    
    def self.attributes_for_api
      %w(id name _type label populate drop_down_target_is_relatable related_attribute order rules filters description drop_down_target_id default_value ui_attributes options prompt max_options object_name order  extra_info css_classes)
    end
    
    protected
    def relatable_categories(related_attribute = self.related_attribute)
      @relatable_categories ||= QuestionChain.calculated_session.relatable_categories_for_object_template(object_name, related_attribute, :per_page => per_page).relatable_categories
    end
    
    # @todo move to after save; check for existing
    def add_default_rule
      if default_rule
        self.rules << Rules::PopulateDropDown.new
        self.save
      end
    end
        
  end
end