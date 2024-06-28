require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::UkAddress do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  include_context "sanitize fields", %i[address_postcode]

  it { is_expected.to be_contains_personal_details }

  describe "attributes" do
    it { is_expected.to respond_to :address_postcode }
  end

  describe "#address_postcode" do
    it { is_expected.not_to allow_values("", nil).for :address_postcode }
    it { is_expected.to allow_values("eh3 9eh", "TR1 1XY", "hs13eq").for :address_postcode }
  end

  describe "#skipped?" do
    it "returns false if uk_or_overseas is UK" do
      wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:uk]
      expect(subject).not_to be_skipped
    end

    it "returns true if returning_to_teaching is Overseas" do
      wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:overseas]
      expect(subject).to be_skipped
    end
  end
end
