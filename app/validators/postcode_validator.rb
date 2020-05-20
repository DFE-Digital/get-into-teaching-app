class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && invalid_postcode?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def invalid_postcode?(postcode)
    !UKPostcode.parse(postcode).full_valid?
  end
end
