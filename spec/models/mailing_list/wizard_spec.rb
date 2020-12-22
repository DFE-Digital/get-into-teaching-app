require "rails_helper"

describe MailingList::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        MailingList::Steps::Name,
        MailingList::Steps::Authenticate,
        MailingList::Steps::AlreadySubscribed,
        MailingList::Steps::DegreeStatus,
        MailingList::Steps::TeacherTraining,
        MailingList::Steps::Subject,
        MailingList::Steps::Postcode,
        MailingList::Steps::PrivacyPolicy,
      ]
    end
  end

  describe "#perform_auth_request" do
    let(:wizardstore) { Wizard::Store.new({}) }
    let(:wizard) { described_class.new wizardstore, "name" }
    let(:candidate_id) { "abc" }
    let(:token) { "def" }
    let(:stub_response) { GetIntoTeachingApiClient::MailingListAddMember.new(candidateId: candidate_id) }

    it "authenticates with the API" do
      expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:get_pre_filled_mailing_list_add_member_long_lived).with(candidate_id, token) { stub_response }
      response = wizard.perform_auth_request(candidate_id, token)
      expect(response).to eq(stub_response)
    end
  end

  describe "#complete!" do
    let(:uuid) { SecureRandom.uuid }
    let(:store) do
      { uuid => {
        "email" => "email@address.com",
        "first_name" => "Joe",
        "last_name" => "Joseph",
      } }
    end
    let(:wizardstore) { Wizard::Store.new store[uuid] }
    let(:request) do
      GetIntoTeachingApiClient::MailingListAddMember.new(
        { email: "email@address.com", firstName: "Joe", lastName: "Joseph" },
      )
    end

    subject { described_class.new wizardstore, "privacy_policy" }

    before { allow(subject).to receive(:valid?).and_return true }
    before do
      expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:add_mailing_list_member).with(request).once
    end
    before { subject.complete! }

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }
  end
end
