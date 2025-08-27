require "rails_helper"

describe MailingList::Steps::Location do
  include_context "with wizard step"

  let(:locations) do
    %i[united_kingdom outside_united_kingdom].map { |trait| build(:location, trait) }
  end
  let(:location_ids) { locations.map(&:id) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_location) { locations }
  end

  it_behaves_like "a with wizard step"
  it { is_expected.to respond_to :location }
  it { is_expected.not_to allow_value(nil).for :location }
  it { is_expected.not_to allow_value("").for :location }
  it { is_expected.not_to allow_value(12_345).for :location }
  it { is_expected.not_to allow_values(0).for(:location) }
  it { is_expected.to validate_inclusion_of(:location).in_array(location_ids) }

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:citizenship) { instance_double(MailingList::Steps::Citizenship, uk_citizen?: uk_citizen) }
    end

    context "when a UK citizen" do
      let(:uk_citizen) { true }

      it "is skipped when a UK citizen" do
        is_expected.to be_skipped
      end
    end

    context "when a non-UK citizen" do
      let(:uk_citizen) { false }

      it "is not skipped when a non-UK citizen" do
        is_expected.not_to be_skipped
      end
    end
  end
end
