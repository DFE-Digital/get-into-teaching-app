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
    include_context "wizard data"

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
          teaching_subjects.each_value do |ts|
            expect(subject).to allow_value(ts).for(:preferred_teaching_subject_id)
          end
        end

        specify "doesn't allow other values" do
          %w[abc 123].each do |invalid|
            expect(subject).not_to allow_value(invalid).for(:preferred_teaching_subject_id).with_message(message)
          end
        end
      end
    end

    describe "#consideration_journey_stage_id" do
      let(:journey_stages) { GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_journey_stages }
      let(:message) { "Choose an option from the list" }

      it { is_expected.to validate_presence_of(:consideration_journey_stage_id).with_message(message) }

      describe "values" do
        specify "allows teaching subject values" do
          journey_stages.map(&:id).each do |js|
            expect(subject).to allow_value(js).for(:consideration_journey_stage_id)
          end
        end

        specify "doesn't allow other values" do
          %w[abc 123].each do |invalid|
            expect(subject).not_to allow_value(invalid).for(:consideration_journey_stage_id).with_message(message)
          end
        end
      end
    end

    describe "#degree_status_id" do
      let(:degree_statuses) { GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status }
      let(:message) { "Select your degree stage from the list" }

      it { is_expected.to validate_presence_of(:degree_status_id).with_message(message) }

      describe "values" do
        specify "allows teaching subject values" do
          degree_statuses.map(&:id).each do |ds|
            expect(subject).to allow_value(ds).for(:degree_status_id)
          end
        end

        specify "doesn't allow other values" do
          %w[abc 123].each do |invalid|
            expect(subject).not_to allow_value(invalid).for(:degree_status_id).with_message(message)
          end
        end
      end
    end

    describe "#accept_privacy_policy" do
      let(:message) { "Accept the privacy policy to continue" }
      it { is_expected.to validate_presence_of(:accept_privacy_policy).with_message(message) }
      it { is_expected.to validate_acceptance_of(:accept_privacy_policy).with_message(message) }
    end

    describe "timed one time password" do
      subject { described_class.new(email: "test@test.org") }

      before do
        allow_any_instance_of(described_class).to receive(:timed_one_time_password_is_correct) do
          true
        end
      end

      it { is_expected.to allow_value("000000").for(:timed_one_time_password).on(:verify) }
      it { is_expected.to allow_value(" 123456").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("abc123").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("1234567").for(:timed_one_time_password).on(:verify) }
      it { is_expected.not_to allow_value("12345").for(:timed_one_time_password).on(:verify) }
    end
  end
end
