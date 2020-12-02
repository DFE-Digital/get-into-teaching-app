class PostcodeValidator < ActiveModel::EachValidator
  PATTERN = %r{\A([A-Z][A-HJ-Y]?\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2})\Z}.freeze

  def validate_each(record, attribute, value)
    if value.present? && invalid_postcode?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def invalid_postcode?(postcode)
    !PATTERN.match?(postcode)
  end
end
