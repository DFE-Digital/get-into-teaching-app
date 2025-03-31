require "rails_helper"
require "digest"

describe MailingList::Wizard do
  subject { described_class.new wizardstore, "postcode" }

  let(:uuid) { SecureRandom.uuid }
  let(:degree_status_id) { Crm::OptionSet.lookup_by_key(:degree_status, :graduate_or_postgraduate) }
  let(:consideration_journey_stage_id) { Crm::OptionSet.lookup_by_key(:consideration_journey_stages, :it_s_just_an_idea) }
  let(:preferred_teaching_subject_id) { Crm::TeachingSubject.lookup_by_key(:physics) }
  let(:store) do
    { uuid => {
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
      "degree_status_id" => degree_status_id,
      "consideration_journey_stage_id" => consideration_journey_stage_id,
      "preferred_teaching_subject_id" => preferred_teaching_subject_id.to_s,
      "accepted_policy_id" => "789",
      "graduation_year" => "2025",
    } }
  end
  let(:wizardstore) { GITWizard::Store.new store[uuid], {} }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        MailingList::Steps::Name,
        ::GITWizard::Steps::Authenticate,
        MailingList::Steps::AlreadySubscribed,
        MailingList::Steps::ReturningTeacher,
        MailingList::Steps::AlreadyQualified,
        MailingList::Steps::DegreeStatus,
        MailingList::Steps::TeacherTraining,
        MailingList::Steps::Subject,
        MailingList::Steps::Postcode,
      ]
    end
  end

  describe "#matchback_attributes" do
    it do
      expect(subject.matchback_attributes).to match_array(%i[candidate_id qualification_id])
    end
  end

  describe "#complete!" do
    # let(:variant) { "/email/subject/physics/degree-status/final_year" }
    let(:variant) { "/email/subject/physics/degree-status/graduate_or_postgraduate" }
    let(:request) do
      GetIntoTeachingApiClient::MailingListAddMember.new({
        email: wizardstore[:email],
        first_name: wizardstore[:first_name],
        last_name: wizardstore[:last_name],
        degree_status_id: degree_status_id,
        consideration_journey_stage_id: consideration_journey_stage_id,
        preferred_teaching_subject_id: wizardstore[:preferred_teaching_subject_id],
        welcome_guide_variant: variant,
        accepted_policy_id: wizardstore[:accepted_policy_id],
        graduation_year: wizardstore[:graduation_year],
      })
    end

    before do
      allow(subject).to receive(:valid?).and_return(true)
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
        receive(:add_mailing_list_member).with(request)
      allow(Rails.logger).to receive(:info)
    end

    context "with prune! spy" do
      before { allow(wizardstore).to receive(:prune!) }

      it "prunes the store, retaining certain attributes" do
        subject.complete!
        expect(wizardstore).to have_received(:prune!).with({ leave: MailingList::Wizard::ATTRIBUTES_TO_LEAVE }).once
      end
    end

    it "checks the wizard is valid" do
      subject.complete!
      is_expected.to have_received(:valid?)
    end

    it "prunes the store, retaining certain attributes" do
      hashed_email = Digest::SHA256.hexdigest("email@address.com")
      subject.complete!
      expect(store[uuid]).to eql({
        "first_name" => wizardstore[:first_name],
        "last_name" => wizardstore[:last_name],
        "hashed_email" => hashed_email,
        "degree_status_id" => wizardstore[:degree_status_id],
        "consideration_journey_stage_id" => wizardstore[:consideration_journey_stage_id],
        "preferred_teaching_subject_id" => wizardstore[:preferred_teaching_subject_id],
        "graduation_year" => wizardstore[:graduation_year],
      })
    end

    it "logs the request model (filtering sensitive attributes)" do
      subject.complete!

      filtered_json = {
        "candidateId" => nil,
        "qualificationId" => nil,
        "preferredTeachingSubjectId" => request.preferred_teaching_subject_id,
        "acceptedPolicyId" => request.accepted_policy_id,
        "considerationJourneyStageId" => request.consideration_journey_stage_id,
        "degreeStatusId" => request.degree_status_id,
        "channelId" => nil,
        "email" => "[FILTERED]",
        "firstName" => "[FILTERED]",
        "lastName" => "[FILTERED]",
        "addressPostcode" => nil,
        "welcomeGuideVariant" => variant,
        "graduationYear" => "2025",
      }.to_json

      expect(Rails.logger).to have_received(:info).with("MailingList::Wizard#add_mailing_list_member: #{filtered_json}")
    end

    context "when not qualified for the welcome guide" do
      let(:degree_status_id) { Crm::OptionSet.lookup_by_key(:degree_status, :not_yet_i_m_studying_for_one) }
      let(:variant) { nil }

      it "does not populate the welcome_guide_variant field" do
        allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
          receive(:add_mailing_list_member).with(request)
        subject.complete!

        expect(request.welcome_guide_variant).to be_nil
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
