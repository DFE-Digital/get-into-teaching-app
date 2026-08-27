require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::DegreeCountry do
  include_context "with a TTA wizard step"
  include_context "with wizard data"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :degree_country }
    it { is_expected.to respond_to :degree_type_id }
  end

  describe "#degree_country" do
    it { is_expected.not_to allow_value("").for :degree_country }
    it { is_expected.not_to allow_value(nil).for :degree_country }
    it { is_expected.not_to allow_value("Denmark").for :degree_country }
    it { is_expected.to allow_values(described_class::UK, described_class::ANOTHER_COUNTRY).for :degree_country }
  end

  describe "#degree_type_id" do
    it { is_expected.not_to allow_value("").for :degree_type_id }
    it { is_expected.not_to allow_value(nil).for :degree_type_id }
    it { is_expected.not_to allow_value(1234).for :degree_type_id }
    it { is_expected.to allow_values(described_class::DEGREE, described_class::DEGREE_EQUIVALENT).for :degree_type_id }

    it "sets degree_type_id to DEGREE when degree_country is set to UK" do
      instance.degree_country = described_class::UK
      expect(instance.degree_type_id).to eql(described_class::DEGREE)
    end

    it "sets degree_type_id to DEGREE_EQUIVALENT when degree_country is set to ANOTHER_COUNTRY" do
      instance.degree_country = described_class::ANOTHER_COUNTRY
      expect(instance.degree_type_id).to eql(described_class::DEGREE_EQUIVALENT)
    end
  end

  describe "#another_country?" do
    it { is_expected.not_to be_another_country }

    context "when UK has been selected" do
      before { instance.degree_country = described_class::UK }

      it { is_expected.not_to be_another_country }
    end

    context "when another country has been selected" do
      before { instance.degree_country = described_class::ANOTHER_COUNTRY }

      it { is_expected.to be_another_country }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.degree_country = described_class::ANOTHER_COUNTRY }

    it { is_expected.to eq({ "degree_country" => "Another Country" }) }
  end
end
