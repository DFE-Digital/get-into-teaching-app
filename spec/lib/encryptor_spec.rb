require "rails_helper"
require "encryptor"

RSpec.describe Encryptor do
  let(:value) { "value" }

  describe ".encrypt" do
    subject { described_class.encrypt(value) }

    it { is_expected.to eq("Nx6SYGs2QI1VtbD") }

    context "when nil" do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe ".decrypt_hash" do
    let(:encrypted_value) { described_class.encrypt(value) }

    subject { described_class.decrypt(encrypted_value) }

    it { is_expected.to eq(value) }

    context "when nil" do
      let(:encrypted_value) { nil }

      it { is_expected.to be_nil }
    end
  end
end
