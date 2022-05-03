require "rails_helper"

describe EncryptedAttributes do
  let(:test_model) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Attributes
      include EncryptedAttributes
      encrypt_attributes :name, :email

      attribute :name
      attribute :email
      attribute :height
      attribute :age
    end
  end
  let(:instance) do
    test_model.new(name: "Name", email: "email@address.com", height: nil, age: 20)
  end

  describe "#encrypted_attributes" do
    subject { instance.encrypted_attributes }

    it "encrypts attributes flagged for encryption" do
      is_expected.to include({
        "name" => "7XDiV3FmPhl3",
        "email" => "94PseMsmBtgesaDs9VTMquj0TQzhw6TRvcWOfjYfqNIwVUG6hxY",
        "height" => nil,
        "age" => 20,
      })
    end
  end

  describe ".new_decrypt" do
    let(:encrypted_attributes) { instance.encrypted_attributes }

    subject { test_model.new_decrypt(encrypted_attributes).attributes }

    it { is_expected.to eq(instance.attributes) }

    context "when passed permitted ActionController::Parameters" do
      let(:encrypted_attributes) { ActionController::Parameters.new(instance.encrypted_attributes).permit! }

      it { is_expected.to eq(instance.attributes) }
    end

    context "when passed a malformed value that cannot be decrypted" do
      let(:encrypted_attributes) { { name: "malformed" } }

      it { is_expected.to include({ "height" => nil }) }
    end
  end
end
