class TelephoneValidator < ActiveModel::EachValidator
  TELEPHONE_FORMAT = %r{\A[0-9 ]+\z}.freeze
  MINIMUM_LENGTH = 6

  def validate_each(record, attribute, value)
    return if value.blank?

    if invalid_format?(value) || too_short?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def invalid_format?(telephone)
    TELEPHONE_FORMAT !~ telephone
  end

  def too_short?(telephone)
    telephone.to_s.length < MINIMUM_LENGTH
  end
end
