require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::OverseasCallback do
  it_behaves_like "exposes callback booking quotas"
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :phone_call_scheduled_at }
  end

  describe "#skipped?" do
    it "returns false if callback_offered was true, OverseasCountry/HaveADegree steps were shown and degree_options is equivalent" do
      allow(Rails).to receive(:env) { "preprod".inquiry }
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasTimeZone).to receive(:callback_offered).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).not_to be_skipped
    end

    it "returns true if OverseasCountry was skipped" do
      allow(Rails).to receive(:env) { "preprod".inquiry }
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(true)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is not equivalent" do
      allow(Rails).to receive(:env) { "preprod".inquiry }
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).to be_skipped
    end

    it "returns true if callback_offered is false" do
      allow(Rails).to receive(:env) { "preprod".inquiry }
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasTimeZone).to receive(:callback_offered).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:date_time) { Time.zone.local(2022, 1, 1, 10, 30) }

    before do
      instance.phone_call_scheduled_at = date_time
    end

    it {
      expect(subject).to eq({
        "callback_date" => date_time.to_date,
        "callback_time" => date_time.to_time,
      })
    }

    context "when the phone_call_scheduled_at is nil" do
      let(:date_time) { nil }

      it { is_expected.to eq({ "callback_date" => nil, "callback_time" => nil }) }
    end
  end
end
