module QuestionChain
  module Answers
    extend ActiveSupport::Concern 
    
    included do
      before_filter :get_context
      before_filter :load_contexts, :except => [:fire_object_search, :fire_populate_drop_down]
      respond_to :json, :only => [:fire_object_search, :fire_populate_drop_down]
      helper_method :question_chain_update_answer_path, :question_chain_answer_path, :collection_path
    end
    
    module InstanceMethods
      def new
        @answer = build_resource
        enforce_permission
        @question = question_from_context
        new!
      end

      def edit
        @answer = resource
        enforce_permission
        @question = Question.find(resource.question_id).to_hash
        @answer_params = @answer.answer_params # used for mustache templates
        set_answer_values_on_question!(@question, @answer_params)
        edit!
      end

      def update
        @answer = resource
        enforce_permission
        @answer.user_id = current_user.id
        @answer.answer_params = params[:answer]
        @answer_params = params[:answer] # used for mustache templates
        @question = Question.find(resource.question_id).to_hash
        @answer.result = get_answer(@question, @answer_params)
        set_answer_values_on_question!(@question, @answer_params)
        build_answer_errors! 
        update! do |success, failure|
          success.html do 
             flash[:notice] = update_success_flash_message
            @contexts << @answer
            redirect_to update_success_path
          end
        end
      end

      def create
        @answer = build_resource
        enforce_permission
        @answer.user_id = current_user.id
        @answer.answer_params = params[:answer]
        @answer_params = params[:answer] # used for mustache templates
        @question = question_from_context
        @answer.question_id = @question.id
        @answer.result = get_answer(@question, @answer_params)
        set_answer_values_on_question!(@question, @answer_params)
        build_answer_errors!
        create! do |success, failure|
          success.html do
            flash[:notice] = create_success_flash_message
            @contexts << @answer
            redirect_to create_success_path
          end      
        end
      end

      # == Rule firing for drop down
      def fire_populate_drop_down
        if ui_object = UiObject.find(params[:ui_object_id])
          if rule = ui_object.rules.find(params[:rule_id])
            return render :json => {"options" => rule.get_options(params[:object_ids])}.to_json
          end
        end
        render :json => {:error => "Could not find rule"}.to_json
      end

      # == Rule firing for search
      def fire_object_search
        if ui_object = UiObject.find(params[:ui_object_id])
          if rule = ui_object.rules.find(params[:rule_id])
            return render :json => {"options" => rule.get_options(params[:q], params[:relatable_category_values])}.to_json
          end
        end
        render :json => {:error => "Could not find rule"}.to_json
      end

      # seems strange but its true allows
      # for pagination link to work inside list view
      # when editing
      def show
        end_of_association_chain
        redirect_to edit_from_context_path
      end

      # seems strange but its true
      # allows for pagination link to work
      # when creating a new answer
      def index
        end_of_association_chain
        redirect_to new_from_context_path
      end
      
      def enforce_permission
        # override to force permission on the answer object
      end
    
      protected
      def create_success_flash_message
        "Your co2 was #{@answer.result["calculations"]["co2"]["value"]} #{@answer.result["calculations"]["co2"]["units"]}"
      end
      
      def update_success_flash_message
        "Your co2 was updated to #{@answer.result["calculations"]["co2"]["value"]} #{@answer.result["calculations"]["co2"]["units"]}"
      end
      
      def question_chain_answer_path
        contexts = @contexts.dup
        contexts << :answers
        self.send(path_method_from_contexts(contexts), {:context => @context, :question_id => @question.id})
      end
 
      def question_chain_update_answer_path
        contexts = @contexts.dup
        contexts << :answer
        self.send(path_method_from_contexts(contexts), {:context => @context, :question_id => @question.id, :id => resource.id})
      end

      # allows the ui to know what values have been set 
      # and therefore sets the ui_objects values
      #
      # @param [Hash] question hash representation of the question
      # @param [Hash] answer_params
      def set_answer_values_on_question!(question_hash, answer)
        answer.each_pair do |key, value| 
          question_hash.ui_groups.map{|group| group.ui_objects}.flatten.each do |ui_object|
            if ui_object.name == key.to_s
              ui_object.value = value
            end
          end
        end
      end

      # @param [Question] calculator_id
      # @param [Hash] answer_params
      # @return [Hash] the result from the co2 computation
      #   which many container errors
      def get_answer(question, answer_params)
        if computation_id = answer_params[:computation_id].blank? ? question.computation_id : answer_params[:computation_id]
          QuestionChain.calculated_session.answer_for_computation(computation_id, answer_params)
        elsif calculator_id = question.calculator_id
          QuestionChain.calculated_session.answer_for_calculator(calculator_id, answer_params)
        end
      end

      # we false the generation of any normal errors
      # on the answer and merge in the carboncalculated 
      # errors as well
      #
      # base errors are in the form of an array
      # errors that have fields are in the form of a hash
      def build_answer_errors!
        if @answer.result[:errors]
          @answer.valid?
          if @answer.result[:errors].is_a?(Hash)
            @answer.errors.merge!(@answer.result[:errors])
          else
            @answer.errors.merge!({:base => @answer.result[:errors]})
          end
          @answer.errors.each_pair{|key, value| value.respond_to?(:flatten!) ? value.flatten! : value}
          @answer.instance_exec(@answer) do |answer| 
            def answer.valid?
              false
            end
            # we dont want this to update any attributes if its invalid!
            # this results in a very strange BUG! if not applied
            def answer.update_attributes(attributes)
              false
            end
          end
        end
      end

      def find_question_ids
        if template = get_chain_template_for_resource(parent_type.to_s)
          template["context"][params[:context]]
        else
          # render not found or something
        end
      end

      def question_from_context
        if question_id = params[:question_id]
           Question.find(question_id).to_hash
        else
           ids = find_question_ids
           Question.find(ids.first).to_hash
        end
      end

      def resource_collection_name
        @context
      end

      # handle single resource case scenerio via singularize
      def resource
        if resource_collection_name.singularize == resource_collection_name
          get_resource_ivar || set_resource_ivar(end_of_association_chain)
        else
          get_resource_ivar || set_resource_ivar(end_of_association_chain.find(params[:id]))
        end
      end

      def collection
         get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page], :per_page => 25, :order => :created_at.desc))
      end

      def get_context
        @context = params[:context]
      end

      # Loads the contexts and any parent resources
      # to allow easy generation of urls back to 
      # the context enclosing resources
      def load_contexts(enclosed_parent = nil)
        end_of_association_chain
        @contexts = [] if @contexts.nil?
        enclosed_parent = enclosed_parent.nil? ? self.parent : enclosed_parent
        unless @contexts.include?(enclosed_parent)
          @contexts << enclosed_parent
          if chain_template = get_chain_template_for_resource(parent.class.name.downcase)
            if parent_resource = chain_template.parent_resource
              resource = parent.send(parent_resource)
              instance_variable_set("@#{parent_resource}", resource)
              load_contexts(resource)
            end
          end
        end
        @contexts.reverse!
      end

      def new_from_context_path
        new_polymorphic_path(@contexts)
      end

      def edit_from_context_path
        new_polymorphic_path(@contexts)
      end

      # if a method matching the context and action that will be called
      # otherwise the polymorphic path is used
      def create_success_path
        if self.respond_to?(path_method_from_contexts(@contexts, "create_success_"))
          self.send(path_method_from_contexts(@contexts, "create_success_"))
        else
          polymorphic_path(@contexts)  
        end
      end

      # builds a url method from the contexts and a given action
      # @param [String] action
      #
      # @return [String] url method call
      def path_method_from_contexts(contexts, action = "")
        url_method = contexts.inject("#{action}") do |string, parent|
          segment = (parent.is_a?(Symbol)) ? parent.to_s : ActiveModel::Naming.singular(parent)
          string << segment
          string << "_"
        end
        url_method << "path"
        url_method
      end

      # if a method has been decleared of a specific update that is called
      # otherwise the default polymophic path is used
      def update_success_path
        if self.respond_to?(path_method_from_contexts(@contexts, "update_success_"))
          self.send(path_method_from_contexts(@contexts, "update_success_"))
        else
          polymorphic_path(@contexts)  
        end
      end

      def get_chain_template_for_resource(for_resource)
        ChainTemplate.first(:conditions => {:model_state => "active", :for_resource => for_resource, :account_id => @account.try(:id)}) ||
        ChainTemplate.first(:conditions => {:model_state => "active", :for_resource => for_resource})
      end
    end
  end
end