require "rails_helper"

describe MailingList::Wizard do
  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    { uuid => {
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
    } }
  end
  let(:wizardstore) { Wizard::Store.new store[uuid], {} }
  subject { described_class.new wizardstore, "privacy_policy" }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        MailingList::Steps::Name,
        ::Wizard::Steps::Authenticate,
        MailingList::Steps::AlreadySubscribed,
        MailingList::Steps::DegreeStatus,
        MailingList::Steps::TeacherTraining,
        MailingList::Steps::Subject,
        MailingList::Steps::Postcode,
        MailingList::Steps::PrivacyPolicy,
      ]
    end
  end

  describe "#complete!" do
    let(:request) do
      GetIntoTeachingApiClient::MailingListAddMember.new(
        { email: "email@address.com", firstName: "Joe", lastName: "Joseph" },
      )
    end

    before do
      allow(subject).to receive(:valid?) { true }
      expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:add_mailing_list_member).with(request).once
      subject.complete!
    end

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::MailingListAddMember.new }

    before do
      expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:exchange_access_token_for_mailing_list_add_member)
        .with(totp, request) { response }
    end

    it "calls exchange_magic_link_token_for_mailing_list_add_member" do
      expect(subject.exchange_access_token(totp, request)).to eq(response)
    end
  end
end
