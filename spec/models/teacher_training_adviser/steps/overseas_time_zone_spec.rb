require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::OverseasTimeZone do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  include_context "sanitize fields", %i[address_telephone]
  include_context "#address_telephone_value"

  it { expect(described_class).to be_contains_personal_details }

  describe "attributes" do
    it { is_expected.to respond_to :time_zone }
    it { is_expected.to respond_to :address_telephone }
    it { is_expected.to respond_to :callback_offered }
  end

  describe "address_telephone" do
    before { instance.callback_offered = true }

    it { is_expected.not_to allow_values(nil, "abc12345", "12", "1" * 21, "000000000").for :address_telephone }
    it { is_expected.to allow_values("123456789").for :address_telephone }
    it { is_expected.to validate_presence_of :address_telephone }

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.not_to validate_presence_of :time_zone }
    end
  end

  describe "#time_zone" do
    before { instance.callback_offered = true }

    it { is_expected.not_to allow_values("", nil).for :time_zone }
    it { is_expected.to allow_values(ActiveSupport::TimeZone.all).for :time_zone }
    it { is_expected.to validate_presence_of :time_zone }

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.not_to validate_presence_of :time_zone }
    end
  end

  describe "#filtered_time_zones" do
    subject { instance.filtered_time_zones }

    it "removes 'International Date Line West' value from ActiveSupport::TimeZones" do
      expect(subject.map(&:name)).not_to include("International Date Line West")
    end
  end

  describe "#skipped?" do
    it "returns false if OverseasCountry was shown and they have an equivalent degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).not_to be_skipped
    end

    it "returns true if OverseasCountry was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is not equivalent" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).to be_skipped
    end
  end

  describe "#export" do
    subject { instance.export.keys }

    it { is_expected.to contain_exactly("address_telephone", "time_zone") }
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before do
      instance.address_telephone = "1234567"
      instance.time_zone = "London"
      instance.callback_offered = true
    end

    it {
      expect(subject).to eq({
        "time_zone" => "London",
        "address_telephone" => "1234567",
      })
    }

    context "when time_zone is nil" do
      before { instance.time_zone = nil }

      it { is_expected.to eq({ "address_telephone" => "1234567" }) }
    end

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.to be_empty }
    end
  end
end
