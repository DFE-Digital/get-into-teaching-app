require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::UkTelephone do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  include_context "sanitize fields", %i[address_telephone]

  it { is_expected.to be_contains_personal_details }
  it { is_expected.to be_optional }

  describe "attributes" do
    it { is_expected.to respond_to :address_telephone }
  end

  describe "address_telephone" do
    it { is_expected.not_to allow_values("abc12345", "12", "1" * 21).for :address_telephone }
    it { is_expected.to allow_values(nil, "123456789").for :address_telephone }
  end

  describe "#skipped?" do
    it "returns false if UkAddress step was shown and degree country is UK" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(false)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(false)
      expect(subject).not_to be_skipped
    end

    it "returns true if UkAddress was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_option is equivalent" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(false)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true when pre-filled with crm data" do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::UkAddress).to receive(:skipped?).and_return(false)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(false)
      wizardstore.persist_preexisting({ "address_telephone" => "123456789" })
      expect(subject).to be_skipped
    end
  end
end
