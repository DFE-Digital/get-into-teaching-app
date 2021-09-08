shared_context "with wizard store" do
  let(:backingstore) { { "name" => "Joe", "age" => 35 } }
  let(:crm_backingstore) { {} }
  let(:wizardstore) { Wizard::Store.new backingstore, crm_backingstore }
end

shared_context "with wizard step" do
  include_context "with wizard store"
  let(:attributes) { {} }
  let(:wizard) { TestWizard.new(wizardstore, TestWizard::Name.key) }
  let(:instance) do
    described_class.new wizard, wizardstore, attributes
  end
  subject { instance }
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
    GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.map do |k, v|
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

shared_examples "an issue verification code with wizard step" do
  describe "#save" do
    before do
      subject.email = "email@address.com"
      subject.first_name = "first"
      subject.last_name = "last"
    end

    let(:request) do
      GetIntoTeachingApiClient::ExistingCandidateRequest.new(
        email: subject.email,
        firstName: subject.first_name,
        lastName: subject.last_name,
      )
    end

    it "purges previous data from the store" do
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
      wizardstore["candidate_id"] = "abc123"
      wizardstore["extra_data"] = "data"
      subject.save
      expect(wizardstore.to_hash).to eq(subject.attributes.merge({
        "authenticate" => true,
        "matchback_failures" => 0,
        "last_matchback_failure_code" => nil,
      }))
    end

    context "when invalid" do
      it "does not call the API" do
        subject.email = nil
        subject.save
        expect_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).not_to receive(:create_candidate_access_token)
        expect(wizardstore["authenticate"]).to be_falsy
        expect(wizardstore["matchback_failures"]).to be_nil
        expect(wizardstore["last_matchback_failure_code"]).to be_nil
      end
    end

    context "when an existing candidate" do
      it "sends verification code and sets authenticate to true" do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
        subject.save
        expect(wizardstore["authenticate"]).to be_truthy
        expect(wizardstore["matchback_failures"]).to eq(0)
        expect(wizardstore["last_matchback_failure_code"]).to be_nil
      end
    end

    it "will skip the authenticate step for new candidates" do
      expect(Rails.logger).to receive(:info).with("#{described_class} requesting access code")
      expect(Rails.logger).not_to receive(:info).with("#{described_class} potential duplicate (response code 404)")
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
        .and_raise(GetIntoTeachingApiClient::ApiError.new(code: 404))
      subject.save
      expect(wizardstore["authenticate"]).to be_falsy
      expect(wizardstore["matchback_failures"]).to eq(1)
      expect(wizardstore["last_matchback_failure_code"]).to eq(404)
    end

    it "will skip the authenticate step if the CRM is unavailable" do
      expect(Rails.logger).to receive(:info).with("#{described_class} requesting access code")
      expect(Rails.logger).to receive(:info).with("#{described_class} potential duplicate (response code 500)")
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
        .and_raise(GetIntoTeachingApiClient::ApiError.new(code: 500))
      subject.save
      expect(wizardstore["authenticate"]).to be_falsy
      expect(wizardstore["matchback_failures"]).to eq(1)
      expect(wizardstore["last_matchback_failure_code"]).to eq(500)
    end

    context "when the API rate limits the request" do
      let(:too_many_requests_error) { GetIntoTeachingApiClient::ApiError.new(code: 429) }

      it "will re-raise the ApiError (to be rescued by the ApplicationController)" do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
          .and_raise(too_many_requests_error)
        expect { subject.save }.to raise_error(too_many_requests_error)
        expect(wizardstore["authenticate"]).to be_nil
        expect(wizardstore["matchback_failures"]).to eq(1)
        expect(wizardstore["last_matchback_failure_code"]).to eq(429)
      end
    end

    it "keeps track of how many times a matchback fails" do
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).with(request)
        .and_raise(GetIntoTeachingApiClient::ApiError.new(code: 404))

      subject.save
      expect(wizardstore["authenticate"]).to be_falsy
      expect(wizardstore["matchback_failures"]).to eq(1)
      expect(wizardstore["last_matchback_failure_code"]).to eq(404)

      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).with(request)
        .and_raise(GetIntoTeachingApiClient::ApiError.new(code: 500))

      subject.save
      expect(wizardstore["matchback_failures"]).to eq(2)
      expect(wizardstore["last_matchback_failure_code"]).to eq(500)

      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).with(request)

      subject.save
      expect(wizardstore["authenticate"]).to be_truthy
      expect(wizardstore["matchback_failures"]).to eq(2)
    end
  end
end

class TestWizard < Wizard::Base
  class Name < Wizard::Step
    attribute :name
    validates :name, presence: true
  end

  # To simulate two steps writing to the same attribute.
  class OtherAge < Wizard::Step
    attribute :age, :integer
    validates :age, presence: false
  end

  class Age < Wizard::Step
    attribute :age, :integer
    validates :age, presence: true
  end

  class Postcode < Wizard::Step
    attribute :postcode
    validates :postcode, presence: true
  end

  self.steps = [Name, OtherAge, Age, Postcode].freeze
end
