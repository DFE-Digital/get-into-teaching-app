# frozen_string_literal: true

class FundingWidgetComponent < ViewComponent::Base
  attr_reader :path, :form

  def initialize(form, path)
    super

    @form = form
    @path = path
  end

  def grouped_options
    subject_groups.map do |group|
      [group, grouped_subjects(group)]
    end
  end

  def error_messages
    form.errors.messages.values.flatten
  end

  def input_field_classes(field)
    "govuk-form-group--error form__field--error" if form.errors[field].any?
  end

  def funding_results
    subject_data&.fetch(:funding, "")
  end

  def next_steps
    subject_data&.fetch(:next_steps, "")
  end

  def sub_head
    subject_data&.fetch(:sub_head, "")
  end

private

  def subjects
    @subjects ||= t("funding_widget.subjects", **{ deep_interpolation: true }.merge(Value.data))
  end

  def subject_groups
    subjects.map { |_k, v| v[:group] }.uniq
  end

  def grouped_subjects(group)
    subjects.select { |_k, v| v[:group] == group }.map { |k, v| [v[:name], k] }
  end

  def subject_data
    subjects[form.subject.to_sym]
  end
end
