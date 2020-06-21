require "rails_helper"

describe EmailFormatValidator do
  class TestModel
    include ActiveModel::Model
    attr_accessor :email_address
    validates :email_address, email_format: true
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  context "invalid addresses" do
    %w[test.com test@@test.com test@test test@test.].each do |email_address|
      let(:instance) { TestModel.new(email_address: email_address) }

      it "#{email_address} should not be valid" do
        is_expected.to include email_address: "is invalid"
      end
    end
  end

  context "valid addresses" do
    %w[test@example.com testymctest@gmail.com test%.mctest@domain.co.uk]
      .each do |email_address|
      let(:instance) { TestModel.new(email_address: email_address) }

      it "#{email_address} should be valid" do
        is_expected.not_to include :email_address
      end
    end
  end
end
