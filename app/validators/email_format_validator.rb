class EmailFormatValidator < ActiveModel::EachValidator
  EMAIL_WITH_FULLY_QUALIFIED_HOSTNAME = %r{\A[^\s@]+@[^\.\s]+\.[^\s]+\z}.freeze

  def validate_each(record, attribute, value)
    unless value.present? && is_an_email_uri?(value) && is_fqdn?(value)
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
end
