shared_context "with wizard store" do
  let(:backingstore) { { "name" => "Joe", "age" => 35 } }
  let(:crm_backingstore) { {} }
  let(:wizardstore) { GITWizard::Store.new backingstore, crm_backingstore }
end

class TestWizard < GITWizard::Base
  class Name < GITWizard::Step
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

shared_context "with a TTA wizard step" do
  subject { instance }

  include_context "with wizard store"
  let(:attributes) { {} }
  let(:wizard) { TeacherTrainingAdviser::Wizard.new(wizardstore, described_class.key) }
  let(:instance) do
    described_class.new wizard, wizardstore, attributes
  end
end

shared_context "with wizard data" do
  let(:degree_status_option_types) do
    Crm::OptionSet::DEGREE_STATUSES.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:consideration_journey_stage_types) do
    Crm::OptionSet::CONSIDERATION_JOURNEY_STAGES.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:teaching_subject_types) do
    Crm::TeachingSubject.all_hash.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  let(:channels) do
    Crm::OptionSet::MAILING_LIST_CHANNELS.map do |k, v|
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

shared_examples "with a wizard step that exposes API lookup items as options" do |api_method, omit_ids, include_ids|
  let(:lookup_items) do
    [
      GetIntoTeachingApiClient::Country.new(id: "1", value: "one"),
      GetIntoTeachingApiClient::Country.new(id: "2", value: "two"),
    ]
  end
  let(:lookup_item_ids) { lookup_items.map(&:id) }

  it { expect(subject.class).to respond_to :options }

  unless include_ids
    it "exposes API lookup items as options" do
      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(api_method) { lookup_items }

      expect(described_class.options.values).to eq(lookup_item_ids)
    end
  end

  if omit_ids
    it "omits options with the ids #{omit_ids}" do
      omitted_lookup_items = omit_ids.map { |id| GetIntoTeachingApiClient::Country.new(id: id, value: "omit-#{id}") }

      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(api_method) { omitted_lookup_items + lookup_items }

      expect(described_class.options.values).to eq(lookup_item_ids)
    end
  end

  if include_ids
    it "includes only options with the ids #{include_ids}" do
      included_lookup_items = include_ids.map { |id| GetIntoTeachingApiClient::Country.new(id: id, value: "include-#{id}") }
      included_lookup_item_ids = included_lookup_items.map(&:id)

      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(api_method) { included_lookup_items + lookup_items }

      expect(described_class.options.values).to eq(included_lookup_item_ids)
    end
  end
end

shared_examples "a wizard step that exposes API pick list items as options" do |api_method, omit_ids, include_ids|
  let(:pick_list_items) do
    [
      GetIntoTeachingApiClient::PickListItem.new(id: 1, value: "one"),
      GetIntoTeachingApiClient::PickListItem.new(id: 2, value: "two"),
    ]
  end
  let(:pick_list_item_ids) { pick_list_items.map(&:id) }

  it { expect(subject.class).to respond_to :options }

  unless include_ids
    it "exposes API pick list items as options" do
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(api_method) { pick_list_items }

      expect(described_class.options.values).to eq(pick_list_item_ids)
    end
  end

  if omit_ids
    it "omits options with the ids #{omit_ids}" do
      omitted_pick_list_items = omit_ids.map { |id| GetIntoTeachingApiClient::PickListItem.new(id: id, value: "omit-#{id}") }

      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(api_method) { omitted_pick_list_items + pick_list_items }

      expect(described_class.options.values).to eq(pick_list_item_ids)
    end
  end

  if include_ids
    it "includes only options with the ids #{include_ids}" do
      included_pick_list_items = include_ids.map { |id| GetIntoTeachingApiClient::PickListItem.new(id: id, value: "include-#{id}") }
      included_pick_list_item_ids = included_pick_list_items.map(&:id)

      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(api_method) { included_pick_list_items + pick_list_items }

      expect(described_class.options.values).to eq(included_pick_list_item_ids)
    end
  end
end
