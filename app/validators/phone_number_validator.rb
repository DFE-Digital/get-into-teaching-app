class PhoneNumberValidator < ActiveModel::EachValidator
  PHONE_NUMBER_FORMAT = %r{\A[0-9 ]+\z}.freeze
  MINIMUM_LENGTH = 6

  def validate_each(record, attribute, value)
    return if value.blank?

    if invalid_format?(value) || too_short?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def invalid_format?(phone_number)
    PHONE_NUMBER_FORMAT !~ phone_number
  end

  def too_short?(phone_number)
    phone_number.to_s.length < MINIMUM_LENGTH
  end
end
