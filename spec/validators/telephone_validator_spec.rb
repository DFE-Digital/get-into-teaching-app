require "rails_helper"

class TelephoneTestModel
  include ActiveModel::Model
  attr_accessor :telephone

  validates :telephone, telephone: true
end

class InternationalTelephoneTestModel
  include ActiveModel::Model
  attr_accessor :telephone

  validates :telephone, telephone: { international: true }
end

RSpec.describe TelephoneValidator do
  subject { instance.errors.details[:telephone] }

  before { instance.valid? }

  context "when the minimum length" do
    let(:instance) { TelephoneTestModel.new(telephone: "12346") }

    it { is_expected.to be_empty }
  end

  context "when the maximum length" do
    let(:instance) { TelephoneTestModel.new(telephone: "1" * 20) }

    it { is_expected.to be_empty }
  end

  context "when too short" do
    let(:instance) { TelephoneTestModel.new(telephone: "1234") }

    it { is_expected.to include error: :too_short }
  end

  context "when too long" do
    let(:instance) { TelephoneTestModel.new(telephone: "1" * 21) }

    it { is_expected.to include error: :too_long }
  end

  context "when invalid format" do
    let(:instance) { TelephoneTestModel.new(telephone: "abc123") }

    it { is_expected.to include error: :invalid }
  end

  context "when international" do
    context "when invalid country dial-in code" do
      let(:instance) { InternationalTelephoneTestModel.new(telephone: "001234535") }

      it { is_expected.to include error: :invalid_dial_in_code }
    end

    context "when valid country dial-in code" do
      let(:instance) { InternationalTelephoneTestModel.new(telephone: "447564738475") }

      it { is_expected.not_to include error: :invalid_dial_in_code }
    end

    context "when valid country dial-in code with leading +" do
      let(:instance) { InternationalTelephoneTestModel.new(telephone: "+447564738475") }

      it { is_expected.not_to include error: :invalid_dial_in_code }
    end

    context "when valid country dial-in code with leading +()" do
      let(:instance) { InternationalTelephoneTestModel.new(telephone: "(44)7564738475") }

      it { is_expected.not_to include error: :invalid_dial_in_code }
    end

    context "when valid country dial-in code with spaces" do
      let(:instance) { InternationalTelephoneTestModel.new(telephone: "4 4 7564 7384 75") }

      it { is_expected.not_to include error: :invalid_dial_in_code }
    end
  end
end
