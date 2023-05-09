class TelephoneValidator < ActiveModel::EachValidator
  TELEPHONE_FORMAT = %r{\A[^a-zA-Z]+\z}
  MINIMUM_LENGTH = 5
  MAXIMUM_LENGTH = 20

  def validate_each(record, attribute, value)
    return if value.blank?

    international = options.key?(:international)

    if international && invalid_dial_in_code?(value)
      record.errors.add(attribute, :invalid_dial_in_code)
    end

    record.errors.add(attribute, :invalid) if invalid_format?(value)
    record.errors.add(attribute, :too_short) if too_short?(value)
    record.errors.add(attribute, :too_long) if too_long?(value)
  end

private

  def invalid_format?(telephone)
    TELEPHONE_FORMAT !~ telephone
  end

  def invalid_dial_in_code?(telephone)
    dial_in_codes = IsoCountryCodes.all.map(&:calling).map { |c| c[1..] }
    sanitized_telephone = telephone.delete("^0-9")
    dial_in_codes.none? { |code| sanitized_telephone.start_with?(code) }
  end

  def too_short?(telephone)
    telephone.to_s.length < MINIMUM_LENGTH
  end

  def too_long?(telephone)
    telephone.to_s.length > MAXIMUM_LENGTH
  end
end
