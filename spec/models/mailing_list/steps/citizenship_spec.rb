require "rails_helper"

describe MailingList::Steps::Citizenship do
  include_context "with wizard step"

  let(:citizenships) do
    %i[uk_citizen non_uk_citizen].map { |trait| build(:citizenship, trait) }
  end
  let(:citizenship_ids) { citizenships.map(&:id) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_citizenship) { citizenships }
  end

  it_behaves_like "a with wizard step"
  it { is_expected.to respond_to :citizenship }
  it { is_expected.not_to allow_value(nil).for :citizenship }
  it { is_expected.not_to allow_value("").for :citizenship }
  it { is_expected.not_to allow_value(12_345).for :citizenship }
  it { is_expected.not_to allow_values(0).for(:citizenship) }
  it { is_expected.to validate_inclusion_of(:citizenship).in_array(citizenship_ids) }
end
