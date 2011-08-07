class MustacheHandler

  class_attribute :default_format
  self.default_format = :mustache

  # this string given is evaled in the context of the view_context
  # therefore we can generate from that basis
  def call(template)
    # virtual path is just a method in the new version of rails so can update from there!
    virtual_path = template.respond_to?(:virtual_path) ? template.virtual_path : template.details[:virtual_path]
    mustache_class_name = "#{virtual_path}_view".classify
    mustache_class = mustache_class_name.constantize
    "#{mustache_class}.new(self, %Q(#{template.source})).render.html_safe"
  end
  
end
