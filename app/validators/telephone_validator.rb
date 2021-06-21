class TelephoneValidator < ActiveModel::EachValidator
  TELEPHONE_FORMAT = %r{\A[^a-zA-Z]+\z}.freeze
  MINIMUM_LENGTH = 5
  MAXIMUM_LENGTH = 20

  def validate_each(record, attribute, value)
    return if value.blank?

    if invalid_format?(value) || too_short?(value) || too_long?(value)
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

  def too_long?(telephone)
    telephone.to_s.length > MAXIMUM_LENGTH
  end
end
