require "rails_helper"

describe MailingList::Wizard do
  subject { described_class.new wizardstore, "privacy_policy" }

  let(:uuid) { SecureRandom.uuid }
  let(:degree_status_id) { OptionSet.lookup_by_key(:degree_status, :final_year) }
  let(:store) do
    { uuid => {
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
      "degree_status_id" => degree_status_id,
      "preferred_teaching_subject_id" => "456",
      "accepted_policy_id" => "789",
    } }
  end
  let(:wizardstore) { DFEWizard::Store.new store[uuid], {} }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        MailingList::Steps::Name,
        ::DFEWizard::Steps::Authenticate,
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
    let(:variant) { "degree_status_id=#{degree_status_id}&preferred_teaching_subject_id=456" }
    let(:request) do
      GetIntoTeachingApiClient::MailingListAddMember.new({
        email: wizardstore[:email],
        first_name: wizardstore[:first_name],
        last_name: wizardstore[:last_name],
        degree_status_id: degree_status_id,
        preferred_teaching_subject_id: wizardstore[:preferred_teaching_subject_id],
        welcome_guide_variant: variant,
        accepted_policy_id: wizardstore[:accepted_policy_id],
      })
    end

    before do
      allow(subject).to receive(:valid?).and_return(true)
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:add_mailing_list_member).with(request)
      allow(Rails.logger).to receive(:info)
      allow(wizardstore).to receive(:prune!).and_call_original
    end

    it "checks the wizard is valid" do
      subject.complete!
      is_expected.to have_received(:valid?)
    end

    it "prunes the store, retaining certain attributes" do
      subject.complete!
      expect(store[uuid]).to eql({
        "first_name" => wizardstore[:first_name],
        "last_name" => wizardstore[:last_name],
        "degree_status_id" => wizardstore[:degree_status_id],
        "preferred_teaching_subject_id" => wizardstore[:preferred_teaching_subject_id],
      })
      expect(wizardstore).to have_received(:prune!).with({ leave: MailingList::Wizard::ATTRIBUTES_TO_LEAVE }).once
    end

    it "logs the request model (filtering sensitive attributes)" do
      subject.complete!

      filtered_json = {
        "candidateId" => nil,
        "qualificationId" => nil,
        "preferredTeachingSubjectId" => request.preferred_teaching_subject_id,
        "acceptedPolicyId" => request.accepted_policy_id,
        "degreeStatusId" => request.degree_status_id,
        "channelId" => nil,
        "email" => "[FILTERED]",
        "firstName" => "[FILTERED]",
        "lastName" => "[FILTERED]",
        "addressPostcode" => nil,
        "welcomeGuideVariant" => request.welcome_guide_variant,
      }.to_json

      expect(Rails.logger).to have_received(:info).with("MailingList::Wizard#add_mailing_list_member: #{filtered_json}")
    end

    context "when not qualified for the welcome guide" do
      let(:degree_status_id) { OptionSet.lookup_by_key(:degree_status, :first_year) }
      let(:variant) { nil }

      it "does not populate the welcome_guide_variant field" do
        allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
          receive(:add_mailing_list_member).with(request)
        subject.complete!
      end
    end
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::MailingListAddMember.new(candidate_id: "123", email: "12345") }

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
