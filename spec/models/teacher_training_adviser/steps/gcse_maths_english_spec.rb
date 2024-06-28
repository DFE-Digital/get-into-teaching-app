require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::GcseMathsEnglish do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :has_gcse_maths_and_english_id }
  end

  describe "has_gcse_maths_and_english_id" do
    it { is_expected.not_to allow_values(nil, 123).for :has_gcse_maths_and_english_id }
    it { is_expected.to allow_values(*TeacherTrainingAdviser::Steps::GcseMathsEnglish::OPTIONS.values).for :has_gcse_maths_and_english_id }
  end

  describe "#skipped?" do
    it "returns true if WhatDegreeClass was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::WhatDegreeClass).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns false if WhatDegreeClass was not skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::WhatDegreeClass).to receive(:skipped?).and_return(false)
      expect(subject).not_to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.has_gcse_maths_and_english_id = Crm::BooleanType::ALL["Yes"] }

    it { is_expected.to eq({ "has_gcse_maths_and_english_id" => "Yes" }) }
  end
end
