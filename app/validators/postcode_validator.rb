class PostcodeValidator < ActiveModel::EachValidator
  OUTWARD_POSTCODE_PATTERN = /[A-Z][A-HJ-Y]?\d[A-Z\d]?/
  FULL_POSTCODE_PATTERN = /#{OUTWARD_POSTCODE_PATTERN} ?\d[A-Z]{2}|GIR ?0A{2}/

  OUTWARD_OR_FULL_POSTCODE_REGEX = %r{\A(#{OUTWARD_POSTCODE_PATTERN})\z|\A(#{FULL_POSTCODE_PATTERN})\z}
  FULL_POSTCODE_REGEX = %r{\A(#{FULL_POSTCODE_PATTERN})\z}

  attr_reader :accept_partial_postcode

  def initialize(options)
    super
    @accept_partial_postcode = options[:accept_partial_postcode]
  end

  def validate_each(record, attribute, value)
    if value.present? && invalid_postcode?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def validation_regex
    accept_partial_postcode ? OUTWARD_OR_FULL_POSTCODE_REGEX : FULL_POSTCODE_REGEX
  end

  def invalid_postcode?(postcode)
    !validation_regex.match?(postcode)
  end
end
