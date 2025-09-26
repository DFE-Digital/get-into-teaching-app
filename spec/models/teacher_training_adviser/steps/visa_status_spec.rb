require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::VisaStatus do
  include_context "with a TTA wizard step"
  include_context "with wizard data"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :visa_status }
  end

  describe "#citizenship" do
    it { is_expected.not_to allow_value("").for :visa_status }
    it { is_expected.not_to allow_value(nil).for :visa_status }
    it { is_expected.not_to allow_value("Denmark").for :visa_status }
    it { is_expected.to allow_values(222_750_000, 222_750_001, 222_750_002).for :visa_status }
  end

  describe "#skipped?" do
    before do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::Citizenship).to receive(:uk_citizen?).and_return(uk_citizen)
    end

    context "when not a uk citizen" do
      let(:uk_citizen) { false }

      it { is_expected.not_to be_skipped }
    end

    context "when a uk citizen" do
      let(:uk_citizen) { true }

      it { is_expected.to be_skipped }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.visa_status = 222_750_001 }

    it { is_expected.to eq({ "visa_status" => "No, I will need to apply for a visa" }) }
  end
end
