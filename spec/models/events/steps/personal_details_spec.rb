require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }

  context "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
  end

  context "email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end

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

    context "when invalid" do
      it "does not call the API" do
        subject.email = nil
        subject.save
        expect_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to_not receive(:create_candidate_access_token)
      end
    end

    context "when an existing candidate" do
      it "sends verification code and sets authenticate to true" do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
        subject.save
        expect(subject.authenticate).to be_truthy
      end
    end

    context "when a new candidate or CRM is unavailable" do
      it "will skip the authenticate step" do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to receive(:create_candidate_access_token).with(request)
          .and_raise(GetIntoTeachingApiClient::ApiError)
        subject.save
        expect(subject.authenticate).to be_falsy
      end
    end
  end
end
