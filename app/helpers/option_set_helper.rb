module OptionSetHelper
  def degree_status_text(option)
    key = option.value.parameterize(separator: "_")
    I18n.t("helpers.answer.mailing_list_steps_degree_status.degree_status.#{key}", **{ default: option.value }.merge(Value.data))
  end

  def format_option_value(option, translation_key = nil)
    I18n.t("helpers.answer.#{translation_key}.#{option.id}", **{ default: option.value }.merge(Value.data))
  end
end
