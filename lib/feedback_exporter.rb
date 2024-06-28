require "csv"

class FeedbackExporter
  EXPORTABLE_ATTRS = %w[
    id
    topic
    rating
    explanation
    created_at
  ].freeze
  CSV_INJECT_CHARS = %w[+ - @ =].freeze

  def initialize(feedback)
    @feedback = feedback
  end

  def to_csv
    CSV.generate do |csv|
      csv << EXPORTABLE_ATTRS
      @feedback.each do |f|
        csv << f.attributes
          .select { |k, _| EXPORTABLE_ATTRS.include?(k) }
          .values
          .map { |v| escape_csv_value(v) }
      end
    end
  end

private

  def escape_csv_value(value)
    str_value = value.to_s.strip

    if CSV_INJECT_CHARS.include?(str_value.chars.first)
      "'#{str_value}"
    else
      str_value
    end
  end
end
