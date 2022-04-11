class EmailFormatValidator < ActiveModel::EachValidator
  EMAIL_WITH_FULLY_QUALIFIED_HOSTNAME = %r{\A[^\s@]+@[^.\s]+\.[^\s]+\z}
  MAXIMUM_LENGTH = 100 # As specified by the CRM

  def validate_each(record, attribute, value)
    unless value.present? && is_an_email_uri?(value) && is_fqdn?(value) && !too_long?(value)
      record.errors.add(attribute, :invalid)
    end
  end

private

  def is_an_email_uri?(value)
    value.to_s.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def is_fqdn?(value)
    value.to_s.match?(EMAIL_WITH_FULLY_QUALIFIED_HOSTNAME)
  end

  def too_long?(value)
    value.to_s.length > MAXIMUM_LENGTH
  end
end
