require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::UkCallback do
  it_behaves_like "exposes callback booking quotas"
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  include_context "sanitize fields", %i[address_telephone]

  it { expect(described_class).to be_contains_personal_details }

  describe "attributes" do
    it { is_expected.to respond_to :phone_call_scheduled_at }
    it { is_expected.to respond_to :address_telephone }
    it { is_expected.to respond_to :callback_offered }
  end

  describe "#phone_call_scheduled_at" do
    before { instance.callback_offered = true }

    it { is_expected.not_to allow_values("", nil, "invalid_date").for :phone_call_scheduled_at }
    it { is_expected.to allow_value(Time.zone.now).for :phone_call_scheduled_at }

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.not_to validate_presence_of :phone_call_scheduled_at }
    end
  end

  describe "#address_telephone" do
    before { instance.callback_offered = true }

    it { is_expected.not_to allow_values(nil, "", "abc12345", "12", "1" * 21).for :address_telephone }
    it { is_expected.to allow_values("123456789").for :address_telephone }

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.not_to validate_presence_of :address_telephone }
    end
  end

  describe "#skipped?" do
    it "returns false if UkAddress/HaveADegree steps were shown and degree_options is equivalent" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).not_to be_skipped
    end

    it "returns true if UkAddress was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(true)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is not equivalent" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:date_time) { Time.zone.local(2022, 1, 1, 10, 30) }
    let(:address_telephone) { "123456789" }

    before do
      instance.phone_call_scheduled_at = date_time
      instance.address_telephone = address_telephone
      instance.callback_offered = true
    end

    it {
      expect(subject).to eq({
        "callback_date" => date_time.to_date,
        "callback_time" => date_time.to_time,
        "address_telephone" => address_telephone,
      })
    }

    context "when the phone_call_scheduled_at/address_telephone are nil" do
      let(:date_time) { nil }
      let(:address_telephone) { nil }

      it { is_expected.to eq({ "callback_date" => nil, "callback_time" => nil, "address_telephone" => nil }) }
    end

    context "when callback_offered is false" do
      before { instance.callback_offered = false }

      it { is_expected.to be_empty }
    end
  end
end
