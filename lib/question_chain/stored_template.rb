module QuestionChain
  class StoredResolver < ActionView::Resolver
    def find_templates(name, prefix, partial, details)
      scope = {:name => name, :prefix => prefix}
      if formats = details[:formats]
        formats = formats.map { |f| f.to_s }
        scope.merge!(:format => formats)
      end

      if locales = details[:locales]
        locales = locales.map { |f| f.to_s }
        scope. merge!(:locale => locales)
      end

      StoredTemplate.all(scope).map do |r|
        handler = ActionView::Template.handler_class_for_extension(r.handler)
        details = { :locale => r.locale, :format => r.format, :partial => r.partial }
        ActionView::Template.new(r.source, "Template Generated From DB: #{details.inspect}: Source #{r.source}", handler, details)
      end
    end
  end

  module TemplateResolver
    extend ActiveSupport::Concern

    included do
      view_paths.unshift StoredResolver.new
    end
  end
end