require "rails_helper"

describe MailingList::Steps::Citizenship do
  include_context "with wizard step"

  let(:uk_citizen) { build(:citizenship, :uk_citizen) }         # 222_750_000
  let(:non_uk_citizen) { build(:citizenship, :non_uk_citizen) } # 222_750_001
  let(:all_citizenships) { [uk_citizen, non_uk_citizen] }
  let(:all_citizenship_ids) { all_citizenships.map(&:id) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to receive(:get_candidate_citizenship) { all_citizenships }
  end

  shared_examples "validate citizenship values" do
    it { is_expected.to respond_to :citizenship }
    it { is_expected.not_to allow_value(nil).for :citizenship }
    it { is_expected.not_to allow_value("").for :citizenship }
    it { is_expected.not_to allow_value(12_345).for :citizenship }
    it { is_expected.not_to allow_values(0).for(:citizenship) }
    it { is_expected.to validate_inclusion_of(:citizenship).in_array(all_citizenship_ids) }
  end

  it_behaves_like "a with wizard step"
  it_behaves_like "validate citizenship values"
end
