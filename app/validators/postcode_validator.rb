class PostcodeValidator < ActiveModel::EachValidator
  OUTWARD_POSTCODE_PATTERN = /[A-Z][A-HJ-Y]?\d[A-Z\d]?/.freeze
  FULL_POSTCODE_PATTERN = /#{OUTWARD_POSTCODE_PATTERN} ?\d[A-Z]{2}|GIR ?0A{2}/.freeze

  OUTWARD_OR_FULL_POSTCODE_REGEX = %r{\A(#{OUTWARD_POSTCODE_PATTERN})\Z|\A(#{FULL_POSTCODE_PATTERN})\Z}.freeze
  FULL_POSTCODE_REGEX = %r{\A(#{FULL_POSTCODE_PATTERN})\Z}.freeze

  attr_reader :outward_only_postcode

  def initialize(options)
    super
    @outward_only_postcode = options[:outward_only_postcode]
  end

  def validate_each(record, attribute, value)
    if value.present? && invalid_postcode?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def validation_regex
    outward_only_postcode ? OUTWARD_OR_FULL_POSTCODE_REGEX : FULL_POSTCODE_REGEX
  end

  def invalid_postcode?(postcode)
    !validation_regex.match?(postcode)
  end
end
