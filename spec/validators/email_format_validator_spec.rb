require "rails_helper"

describe EmailFormatValidator do
  class TestModel
    include ActiveModel::Model
    attr_accessor :email
    validates :email, email_format: true
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  context "invalid addresses" do
    %w[test.com test@@test.com test@test test@test.].each do |email|
      let(:instance) { TestModel.new(email: email) }

      it "#{email} should not be valid" do
        is_expected.to include email: "is invalid"
      end
    end

    context "when over 100 characters" do
      let(:instance) { TestModel.new(email: "#{'a' * 100}@test.com") }

      it "is not be valid" do
        is_expected.to include email: "is invalid"
      end
    end
  end

  context "valid addresses" do
    %w[test@example.com testymctest@gmail.com test%.mctest@domain.co.uk]
      .each do |email|
      let(:instance) { TestModel.new(email: email) }

      it "#{email} should be valid" do
        is_expected.not_to include :email
      end
    end
  end
end
