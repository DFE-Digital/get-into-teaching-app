require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::Location do
  include_context "with a TTA wizard step"
  include_context "with wizard data"
  it_behaves_like "a with wizard step"

  # let(:locations) do
  #   %i[united_kingdom outside_united_kingdom].map { |trait| build(:location, trait) }
  # end
  # let(:location_ids) { locations.map(&:id) }

  # before do
  #   allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_location) { locations }
  # end

  describe "attributes" do
    it { is_expected.to respond_to :location }
  end

  describe "#location" do
    it { is_expected.not_to allow_value("").for :location }
    it { is_expected.not_to allow_value(nil).for :location }
    it { is_expected.not_to allow_value("Denmark").for :location }
    it { is_expected.to allow_values(described_class::INSIDE_THE_UK, described_class::OUTSIDE_THE_UK).for :location }
  end

  describe "#locations" do
    subject { instance.locations }

    it { is_expected.to eql(locations) }
  end

  describe "#location_ids" do
    subject { instance.location_ids }

    it { is_expected.to eql(locations.map(&:id)) }
  end

  describe "#uk?" do
    it { is_expected.not_to be_uk }

    context "when UK has been selected" do
      before { instance.location = described_class::INSIDE_THE_UK }

      it { is_expected.to be_uk }
    end
  end

  describe "#overseas?" do
    it { is_expected.not_to be_overseas }

    context "when Overseas has been selected" do
      before { instance.location = described_class::OUTSIDE_THE_UK }

      it { is_expected.to be_overseas }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    context "when UK has been selected" do
      before { instance.location = described_class::INSIDE_THE_UK }

      it { is_expected.to eq({ "location" => "In the UK" }) }
    end

    context "when Overseas has been selected" do
      before { instance.location = described_class::OUTSIDE_THE_UK }

      it { is_expected.to eq({ "location" => "Outside of the UK" }) }
    end
  end
end
