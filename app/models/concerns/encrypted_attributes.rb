require "encryptor"

module EncryptedAttributes
  extend ActiveSupport::Concern

  included do |_base|
    delegate :encrypt?, to: :class
    class_attribute :encrypted_attributes

    def self.new_decrypt(attributes)
      decrypted_attributes = attributes.to_h.each_with_object({}) do |(k, v), hash|
        hash[k] = encrypt?(k) ? ::Encryptor.decrypt(v) : v
      end

      new(decrypted_attributes)
    end

    def encrypted_attributes
      attributes.each_with_object({}) do |(k, v), hash|
        hash[k] = encrypt?(k) ? ::Encryptor.encrypt(v) : v
      end
    end
  end

  class_methods do
    def encrypt_attributes(*attributes)
      self.encrypted_attributes = attributes.map(&:to_s)
    end

    def encrypt?(key)
      key.to_s.in?(encrypted_attributes)
    end
  end
end
