require "rails_helper"

describe MailingList::Signup do
  describe "attributes" do
    it { is_expected.to respond_to(:preferred_teaching_subject_id) }
    it { is_expected.to respond_to(:consideration_journey_stage_id) }
    it { is_expected.to respond_to(:accept_privacy_policy) }
    it { is_expected.to respond_to :accepted_policy_id }
    it { is_expected.to respond_to(:address_postcode) }
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:channel_id) }
    it { is_expected.to respond_to(:degree_status_id) }
  end

  describe "validation" do
    include_context "with wizard data"

    describe "#email" do
      it { is_expected.to validate_presence_of(:email) }

      describe "format" do
        it { is_expected.to allow_value("me@you.com").for(:email) }
        it { is_expected.to allow_value(" me@you.com ").for(:email) }
        it { is_expected.not_to allow_value("me@you").for(:email).with_message("Enter a valid email address") }
      end
    end

    describe "#first_name" do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_length_of(:first_name).is_at_most(256) }
    end

    describe "#last_name" do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(256) }
    end

    describe "#channel_id" do
      let(:options) { channels.map(&:id) }

      it { is_expected.to allow_values(options).for(:channel_id) }
      it { is_expected.to allow_value(nil, "").for(:channel_id) }
      it { is_expected.not_to allow_value(12_345).for(:channel_id) }
    end

    describe "#preferred_teaching_subject_id" do
      let(:teaching_subjects) { GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS }
      let(:message) { "Choose a subject from the list" }

      it { is_expected.to validate_presence_of(:preferred_teaching_subject_id).with_message(message) }

      describe "values" do
        specify "allows teaching subject values" do
          expect(subject).to allow_value(*teaching_subjects.values).for(:preferred_teaching_subject_id)
        end

        specify "doesn't allow other values" do
          expect(subject).not_to allow_value("abc", "123").for(:preferred_teaching_subject_id).with_message(message)
        end
      end
    end

    describe "#consideration_journey_stage_id" do
      let(:journey_stages) { GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_journey_stages }
      let(:message) { "Choose an option from the list" }

      it { is_expected.to validate_presence_of(:consideration_journey_stage_id).with_message(message) }

      describe "values" do
        specify "allows teaching subject values" do
          expect(subject).to allow_value(*journey_stages.map(&:id)).for(:consideration_journey_stage_id)
        end

        specify "doesn't allow other values" do
          expect(subject).not_to allow_value("abc", "123").for(:consideration_journey_stage_id).with_message(message)
        end
      end
    end

    describe "#degree_status_id" do
      let(:degree_statuses) { GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status }
      let(:message) { "Select your degree stage from the list" }

      it { is_expected.to validate_presence_of(:degree_status_id).with_message(message) }

      describe "values" do
        specify "allows teaching subject values" do
          expect(subject).to allow_value(*degree_statuses.map(&:id)).for(:degree_status_id)
        end

        specify "doesn't allow other values" do
          expect(subject).not_to allow_value("abc", "123").for(:degree_status_id).with_message(message)
        end
      end
    end

    describe "#accept_privacy_policy" do
      let(:message) { "Accept the terms and conditions to continue" }

      it { is_expected.to validate_presence_of(:accept_privacy_policy).with_message(message) }
      it { is_expected.to validate_acceptance_of(:accept_privacy_policy).with_message(message) }
    end

    describe "timed one time password" do
      subject { described_class.new(email: "test@test.org") }

      before do
        allow_any_instance_of(described_class).to receive(:verify_timed_one_password_and_update_identification_info).and_return(true)
      end

      it { is_expected.to allow_value("000000").for(:timed_one_time_password).on(:verify) }
      it { is_expected.to allow_value(" 123456").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("abc123").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("1234567").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("12345").for(:timed_one_time_password).on(:verify) }
    end
  end

  describe "methods" do
    describe "#query_degree_status" do
      before { allow(GetIntoTeachingApiClient::PickListItemsApi).to receive(:new).and_return(api) }

      it { is_expected.to respond_to(:query_channels) }

      let(:api) { instance_double(GetIntoTeachingApiClient::PickListItemsApi) }

      specify "should call the PickListItemsApi" do
        expect(api).to receive(:get_qualification_degree_status)
        subject.send(:query_degree_status)
      end
    end

    describe "#query_channels" do
      before { allow(GetIntoTeachingApiClient::PickListItemsApi).to receive(:new).and_return(api) }

      it { is_expected.to respond_to(:query_channels) }

      let(:api) { instance_double(GetIntoTeachingApiClient::PickListItemsApi) }

      specify "should call the PickListItemsApi" do
        expect(api).to receive(:get_candidate_mailing_list_subscription_channels)
        subject.query_channels
      end
    end

    describe "#teaching_subjects" do
      before { allow(GetIntoTeachingApiClient::LookupItemsApi).to receive(:new).and_return(api) }

      it { is_expected.to respond_to(:teaching_subjects) }

      let(:api) { instance_double(GetIntoTeachingApiClient::LookupItemsApi, get_teaching_subjects: []) }

      specify "should call the LookupItemsApi" do
        expect(api).to receive(:get_teaching_subjects)
        subject.teaching_subjects
      end
    end

    describe "#consideration_journey_stages" do
      before { allow(GetIntoTeachingApiClient::PickListItemsApi).to receive(:new).and_return(api) }

      it { is_expected.to respond_to(:consideration_journey_stages) }

      let(:api) { instance_double(GetIntoTeachingApiClient::PickListItemsApi, get_candidate_journey_stages: []) }

      specify "should call the PickListItemsApi" do
        expect(api).to receive(:get_candidate_journey_stages)
        subject.consideration_journey_stages
      end
    end

    describe "export_data" do
      subject { described_class.new(**attributes) }

      it { is_expected.to respond_to(:consideration_journey_stages) }

      let(:attributes) do
        {
          email: "test@test.com",
          first_name: "martin",
          last_name: "prince",
          degree_status_id: 123,
          consideration_journey_stage_id: 456,
          accept_privacy_policy: "abc-123",
          qualification_id: "def-234",
          candidate_id: "efg-345",
          accepted_policy_id: "fgh-456",
          address_postcode: "M1 2EJ",
        }
      end

      specify "returns a hash with correct data" do
        expect(subject.export_data).to eql(attributes.transform_keys(&:to_s))
      end
    end
  end
end
