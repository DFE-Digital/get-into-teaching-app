shared_context "with wizard store" do
  let(:backingstore) { { "name" => "Joe", "age" => 35 } }
  let(:crm_backingstore) { {} }
  let(:wizardstore) { DFEWizard::Store.new backingstore, crm_backingstore }
end

class TestWizard < DFEWizard::Base
  class Name < DFEWizard::Step
    attribute :name
    validates :name, presence: true
  end

  self.steps = [Name].freeze
end

shared_context "with wizard step" do
  include_context "with wizard store"
  subject { instance }

  let(:attributes) { {} }
  let(:wizard) { TestWizard.new(wizardstore, TestWizard::Name.key) }
  let(:instance) do
    described_class.new wizard, wizardstore, attributes
  end
end

shared_context "with wizard data" do
  let(:degree_status_option_types) do
    GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:consideration_journey_stage_types) do
    GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:teaching_subject_types) do
    TeachingSubject::ALL.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:channels) do
    GetIntoTeachingApiClient::Constants::CANDIDATE_MAILING_LIST_SUBSCRIPTION_CHANNELS.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:latest_privacy_policy) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_journey_stages).and_return(consideration_journey_stage_types)
    allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
      receive(:get_teaching_subjects).and_return(teaching_subject_types)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_mailing_list_subscription_channels).and_return(channels)
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
      receive(:get_latest_privacy_policy).and_return(latest_privacy_policy)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:add_mailing_list_member)
  end
end

shared_examples "a with wizard step" do
  it { expect(subject.class).to respond_to :key }
  it { is_expected.to respond_to :save }
end
