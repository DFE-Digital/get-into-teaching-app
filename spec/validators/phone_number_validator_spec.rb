require "rails_helper"

describe PhoneNumberValidator do
  class PhoneNumberTestModel
    include ActiveModel::Model
    attr_accessor :phone_number
    validates :phone_number, phone_number: true
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  %w[1234 random].each do |number|
    context "checking '#{number}'" do
      let(:instance) { PhoneNumberTestModel.new(phone_number: number) }
      it { is_expected.to include phone_number: "is invalid" }
    end
  end

  %w[01234567890 07123456789].each do |number|
    context "checking '#{number}'" do
      let(:instance) { PhoneNumberTestModel.new(phone_number: number) }
      it { is_expected.not_to include :phone_number }
    end
  end
end
