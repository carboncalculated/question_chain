# @todo Change from a just outright hack!
class MustacheRails < Mustache
  
  def initialize(view_context, template_source)
    @view_context = view_context    
    self.template = template_source
    assign_variables!
  end
    
  def respond_to?(method_sym, include_private = false)
    if @view_context.respond_to?(method_sym) 
      true
    else
      super
    end
  end
  
  def method_missing(method_name, *args, &block)
    if self.respond_to?(method_name.to_sym)
      @view_context.send(method_name,*args, &block)
    else
      super
    end
  end
  
  def template=(template)
    @raw_template = template
    @template = templateify(template)
  end
  
  def render(data = template, ctx = {})
    if self[:_raw] == true
      @raw_template
    else
      templateify(data).render(context.update(ctx))
    end
  end

  
  # we wish to add instance vars from the view_context only 
  # none funcky ones
  private
  def assign_variables!
    variables = @view_context.instance_variable_names.select{|name| name =~ /^@[^_]/}
    variables.each do |name| 
      assign_name = name.gsub(/@/, "_")
      self[assign_name.to_sym] = @view_context.instance_variable_get(name)
    end
  end
end