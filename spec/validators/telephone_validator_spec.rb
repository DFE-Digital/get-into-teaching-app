require "rails_helper"

describe TelephoneValidator do
  class TelephoneTestModel
    include ActiveModel::Model
    attr_accessor :telephone
    validates :telephone, telephone: true
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  %w[1234 random].each do |number|
    context "checking '#{number}'" do
      let(:instance) { TelephoneTestModel.new(telephone: number) }
      it { is_expected.to include telephone: "is invalid" }
    end
  end

  %w[01234567890 07123456789].each do |number|
    context "checking '#{number}'" do
      let(:instance) { TelephoneTestModel.new(telephone: number) }
      it { is_expected.not_to include :telephone }
    end
  end
end
