require "rails_helper"

describe MailingList::Wizard do
  subject { described_class.new wizardstore, "privacy_policy" }

  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    { uuid => {
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
    } }
  end
  let(:wizardstore) { DFEWizard::Store.new store[uuid], {} }

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

  describe "#matchback_attributes" do
    it do
      expect(subject.matchback_attributes).to match_array(%i[candidate_id qualification_id])
    end
  end

  describe "#complete!" do
    let(:request) do
      GetIntoTeachingApiClient::MailingListAddMember.new(
        { email: "email@address.com", firstName: "Joe", lastName: "Joseph" },
      )
    end

    before do
      allow(subject).to receive(:valid?).and_return(true)
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:add_mailing_list_member).with(request)
      allow(Rails.logger).to receive(:info)
      subject.complete!
    end

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({ "first_name" => "Joe", "last_name" => "Joseph" }) }

    it "logs the request model (filtering sensitive attributes)" do
      filtered_json = { "email" => "[FILTERED]", "firstName" => "[FILTERED]", "lastName" => "[FILTERED]" }.to_json
      expect(Rails.logger).to have_received(:info).with("MailingList::Wizard#add_mailing_list_member: #{filtered_json}")
    end
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::MailingListAddMember.new(candidateId: "123", email: "12345") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:exchange_access_token_for_mailing_list_add_member)
        .with(totp, request) { response }
    end

    it "calls exchange_access_token_for_mailing_list_add_member" do
      expect(subject.exchange_access_token(totp, request)).to eq(response)
    end

    it "logs the response model (filtering sensitive attributes)" do
      filtered_json = { "candidateId" => "123", "email" => "[FILTERED]" }.to_json
      expect(Rails.logger).to receive(:info).with("MailingList::Wizard#exchange_access_token: #{filtered_json}")
      subject.exchange_access_token(totp, request)
    end
  end
end
