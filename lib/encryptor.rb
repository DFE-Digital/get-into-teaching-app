class Encryptor
  delegate :encrypt_and_sign, :decrypt_and_verify, to: :crypt

  class << self
    def encrypt(value)
      return nil if value.blank?

      new.encrpyt_string(value)
    end

    def decrypt(value)
      return nil if value.blank?

      new.decrypt_string(value)
    end
  end

  def encrpyt_string(value)
    hashids.encode(value.chars.map(&:ord))
  end

  def decrypt_string(value)
    hashids.decode(value).map(&:chr).join
  end

private

  def hashids
    salt = ENV["SECRET_KEY_BASE"][0..31]
    Hashids.new(salt)
  end
end
