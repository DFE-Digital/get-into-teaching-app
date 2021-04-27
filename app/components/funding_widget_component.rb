# frozen_string_literal: true

class FundingWidgetComponent < ViewComponent::Base
  attr_reader :path, :form

  def initialize(form, path)
    @form = form
    @path = path
  end

  def grouped_options
    {}.tap do |options|
      form.subjects.map { |_k, v| v[:education] }.uniq.each do |education|
        options[education] = form.subjects.select { |_k, v| v[:education] == education }.map { |k, _v| k }
      end
    end
  end

  def error_messages
    form.errors.messages.values.flatten
  end

  def input_field_classes(field)
    return "form__field--error" if form.errors[field].any?
  end

  def funding_results
    form.subject_data&.fetch(:funding, "")
  end

  def sub_head
    form.subject_data&.fetch(:sub_head, "")
  end
end
