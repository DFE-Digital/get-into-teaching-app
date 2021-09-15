require "rails_helper"

describe Wizard::Steps::Authenticate do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  before { allow(wizard).to receive(:exchange_access_token) { {} } }

  it { is_expected.to respond_to :timed_one_time_password }

  context "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:timed_one_time_password) }
  end

  context "timed one time password" do
    it { is_expected.to allow_value("000000").for :timed_one_time_password }
    it { is_expected.to allow_value(" 123456").for :timed_one_time_password }
    it { is_expected.not_to allow_value("abc123").for :timed_one_time_password }
    it { is_expected.not_to allow_value("1234567").for :timed_one_time_password }
    it { is_expected.not_to allow_value("12345").for :timed_one_time_password }
  end

  describe "#skipped?" do
    it "returns true if authenticate is false or nil" do
      wizardstore["authenticate"] = false
      expect(subject).to be_skipped
      wizardstore["authenticate"] = nil
      expect(subject).to be_skipped
    end

    it "returns false if authenticate is true" do
      wizardstore["authenticate"] = true
      expect(subject).not_to be_skipped
    end
  end

  describe "#export" do
    it "returns an empty hash" do
      allow_any_instance_of(described_class).to receive(:skipped?) { false }
      subject.timed_one_time_password = "123456"
      expect(subject.export).to be_empty
    end
  end

  describe "#save" do
    before do
      subject.timed_one_time_password = totp
      wizardstore["email"] = "email@address.com"
      wizardstore["first_name"] = "First"
      wizardstore["last_name"] = "Last"
    end

    let(:totp) { "123456" }
    let(:request) do
      GetIntoTeachingApiClient::ExistingCandidateRequest.new(
        email: wizardstore["email"],
        firstName: wizardstore["first_name"],
        lastName: wizardstore["last_name"],
      )
    end

    context "when invalid" do
      it "does not attempt to call the API" do
        subject.timed_one_time_password = nil
        subject.save
        expect { subject.save }.not_to raise_error
      end
    end

    context "when valid" do
      it "attempts to call the API exactly once for each valid timed_one_time_password" do
        expect(wizard).to receive(:exchange_access_token).with(totp, request).and_raise(GetIntoTeachingApiClient::ApiError).once
        expect(wizard).to receive(:exchange_access_token).with("000000", request).once
        subject.timed_one_time_password = totp
        subject.save
        subject.save
        subject.timed_one_time_password = "000000"
        subject.save
      end

      it "does not call the API on validation if already authenticated" do
        expect(wizard).to receive(:access_token_used?) { true }
        expect(wizard).not_to receive(:exchange_access_token)
        subject.timed_one_time_password = totp
        subject.valid?
      end

      it "throws an error if #exchange_access_token is not defined" do
        expect(wizard).to receive(:exchange_access_token).and_call_original
        expect { subject.save }.to raise_error(DFEWizard::AccessTokenNotSupportedError)
      end
    end

    context "when TOTP is correct" do
      it "updates the store with the response" do
        response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidateId: "abc123")
        expect(wizard).to receive(:exchange_access_token).with(totp, request) { response }
        subject.save
        expect(wizardstore["candidate_id"]).to eq(response.candidate_id)
      end
    end

    context "when TOTP is incorrect" do
      it "is marked as invalid" do
        expect(wizard).to receive(:exchange_access_token).with(totp, request)
          .and_raise(GetIntoTeachingApiClient::ApiError)
        expect(subject).to be_invalid
      end
    end
  end
end
