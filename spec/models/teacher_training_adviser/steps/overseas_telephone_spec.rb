require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::OverseasTelephone do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  include_context "sanitize fields", %i[address_telephone]
  include_context "#address_telephone_value"

  it { is_expected.to be_contains_personal_details }
  it { is_expected.to be_optional }

  describe "attributes" do
    it { is_expected.to respond_to :address_telephone }
  end

  describe "address_telephone" do
    it { is_expected.not_to allow_values("abc12345", "12", "1" * 21, "000000000").for :address_telephone }
    it { is_expected.to allow_values(nil, "123456789").for :address_telephone }
  end

  describe "#skipped?" do
    it "returns false if OverseasCountry was shown and they don't have an equivalent degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).not_to be_skipped
    end

    it "returns true if OverseasCountry was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::OverseasCountry).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is equivalent" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true when pre-filled with crm data" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      wizardstore.persist_preexisting({ "address_telephone" => "123456789" })
      expect(subject).to be_skipped
    end
  end
end
