module OptionSetHelper
  def degree_status_text(option)
    key = option.value.parameterize(separator: "_")
    I18n.t("helpers.answer.mailing_list_steps_degree_status.degree_status.#{key}", **{ default: option.value }.merge(Value.data))
  end
end
