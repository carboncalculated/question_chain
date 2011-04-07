module UiObjects
  class ObjectReferenceDropDown < UiObject
    
    # == Fields
    field :prompt, :type => String
    field :max_options, :type => Integer, :default => 20
    
    # :id => :attribute_name # not quite sure about the option trackers
    key :object_name, :type => String
    key :filters, :type => Set # filters
    key :filter_attribute, :type => String
    key :filter_value, :type => String
    key :order, :type => String
    key :drop_down_target_id, :type => String
    key :drop_down_target_options_filters, Array # == Array of filters for formula inputs
    key :populate, Boolean, :default => true
    key :relatable_options, Boolean, :default => false
    key :attribute_for_value, String, :default => "id"
    key :attribute_for_display, String, :default => "identifier"
    key :external, Boolean, :default => true
    
    # == Indexes
    index :object_name
    
    # == Validations
    validates_presence_of :object_name
        
    def ui_options
      return [] if !populate
      @ui_options ||= get_options(object_name, filters || [])
    end
    
    def self.attributes_for_api
      %w(id name _type label description rules default_value ui_attributes ui_options prompt max_options object_name drop_down_target_id  extra_info css_classes)
    end
    
    # object_reference drop down can only target its formula units basically
    # only 1 object in this instance
    def get_target_drop_down_options(object_ids = [])
      if object_id = object_ids.first
        formula_inputs = QuestionChain.calculated_session.formula_inputs_for_generic_object(object_id.to_s)
        if respond_to?(:drop_down_target_options_filters) && !drop_down_target_options_filters.empty?
          selected_formula_inputs = formula_inputs.select{|f| drop_down_target_options_filters.map(&:downcase).include?(f.name.downcase)}
          selected_formula_inputs.inject({}){|var, fi| var.merge!({fi.name => fi.label_input_units}); var}
        else
          formula_inputs.inject({}){|var, fi| var.merge!({fi.name => fi.label_input_units}); var}
        end
      end
    end
    
    protected
    # Based on the fact we dont know what co2_platform 
    # we are using how can the options be found!
    # 
    # @return [Array<Array<String, String>>] tuples [value, display]
    def get_options(name, filters = [])
      options = {:per_page => per_page}
      options.merge!(:filter_attribute => self.filter_attribute, :filter_value => self.filter_value) if self.filter_attribute && self.filter_value
      response = QuestionChain.calculated_session.generic_objects_for_object_template(name, options)
      options = response.generic_objects.select{|obj| (filters.empty? || (!filters.empty? && filters.include?(obj.id.to_s)))}.map do |obj|      
        {:value => obj.send(self.attribute_for_value), :name => obj.send(self.attribute_for_display)}
      end
      options.sort_by{|obj| obj[:name]}
    end
        
  end
end