module FunnelTitle
  include I18n

  def title
    return unless title_attribute

    title_scope = title_base_scopes
                    .map{ |scope| scope << title_class_name_scope }
                    .find{ |scope| I18n.exists?(title_attribute, scope: scope) }
    if title_scope
      I18n.t title_attribute, scope: title_scope
    end
  end

  def title_attribute
    attributes.keys.first
  end

  def title_class_name_scope
    self.class.name.underscore.gsub("/", "_")
  end

  def title_base_scopes
    [
      [:helpers, :legend],
      [:helpers, :label]
    ]
  end

  def skip_title_suffix?
    false
  end
end
