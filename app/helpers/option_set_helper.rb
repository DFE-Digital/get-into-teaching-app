module OptionSetHelper
  def format_option_value(option, translation_key)
    I18n.t("helpers.answer.#{translation_key}.#{option.id}", **{ default: option.value }.merge(Value.data))
  end

  def format_option_hint(option, translation_key)
    I18n.t("helpers.hint.#{translation_key}.#{option.id}", **{ default: nil }.merge(Value.data))
  end
end
