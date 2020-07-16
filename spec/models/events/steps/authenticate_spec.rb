require "rails_helper"

describe Events::Steps::Authenticate do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :timed_one_time_password }

  context "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:timed_one_time_password) }
  end

  context "timed one time password" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
        .to receive(:get_pre_filled_teaching_event_add_attendee)
    end

    it { is_expected.to allow_value("000000").for :timed_one_time_password }
    it { is_expected.to allow_value(" 123456").for :timed_one_time_password }
    it { is_expected.not_to allow_value("abc123").for :timed_one_time_password }
    it { is_expected.not_to allow_value("1234567").for :timed_one_time_password }
    it { is_expected.not_to allow_value("12345").for :timed_one_time_password }
  end

  describe "skipped?" do
    it "returns true if authenticate is false" do
      wizardstore["authenticate"] = false
      expect(subject).to be_skipped
    end

    it "returns false if authenticate is true" do
      wizardstore["authenticate"] = true
      expect(subject).to_not be_skipped
    end
  end

  describe "#save" do
    before do
      subject.timed_one_time_password = "123456"
      wizardstore["email"] = "email@address.com"
      wizardstore["first_name"] = "First"
      wizardstore["last_name"] = "Last"
    end

    let(:request) do
      GetIntoTeachingApiClient::ExistingCandidateRequest.new(
        email: wizardstore["email"],
        firstName: wizardstore["first_name"],
        lastName: wizardstore["last_name"],
      )
    end

    context "when invalid" do
      it "does not call the API" do
        subject.timed_one_time_password = nil
        subject.save
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to_not receive(:get_pre_filled_teaching_event_add_attendee)
      end
    end

    context "when valid" do
      it "calls the API exactly once for each valid timed_one_time_password" do
        response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_pre_filled_teaching_event_add_attendee)
          .with(anything, anything).exactly(2).times.and_return(response)
        subject.timed_one_time_password = "123456"
        subject.save
        subject.save
        subject.timed_one_time_password = "000000"
        subject.save
      end
    end

    context "when TOTP is correct" do
      it "updates the store with the response" do
        response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidateId: "abc123")
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_pre_filled_teaching_event_add_attendee)
        .with(subject.timed_one_time_password, request).and_return(response)
        subject.save
        expect(wizardstore["candidate_id"]).to eq(response.candidate_id)
      end
    end

    context "when TOTP is incorrect" do
      it "is marked as invalid" do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_pre_filled_teaching_event_add_attendee)
        .with(subject.timed_one_time_password, request)
          .and_raise(GetIntoTeachingApiClient::ApiError)
        subject.save
        expect(subject).to be_invalid
      end
    end
  end
end
