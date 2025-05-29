require "rails_helper"

RSpec.describe MailingListHelper, type: :helper do
  let(:physics_uuid) { Crm::TeachingSubject.lookup_by_key(:physics) }

  shared_context "with first name" do
    before { allow(session).to receive(:dig).with("mailinglist", "first_name") { name } }
  end

  shared_context "with preferred teaching subject set in welcome_guide" do
    before { allow(session).to receive(:dig).with("welcome_guide", "preferred_teaching_subject_id") { subject_id } }
  end

  shared_context "with preferred teaching subject set in welcome_guide and mailinglist" do
    before do
      allow(session).to receive(:dig).with("welcome_guide", "preferred_teaching_subject_id").and_return(nil)
      allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id }
    end
  end

  describe "#high_commitment?" do
    it "returns true for consideration_journey_stage 222750003" do
      expect(high_commitment?(consideration_journey_stage: 222_750_003)).to be true
    end

    it "returns false for other consideration_journey_stage values" do
      expect(high_commitment?(consideration_journey_stage: 123_456_789)).to be false
    end
  end

  describe "#low_commitment?" do
    it "returns true for consideration_journey_stage 222750000" do
      expect(low_commitment?(consideration_journey_stage: 222_750_000)).to be true
    end

    it "returns false for other consideration_journey_stage values" do
      expect(low_commitment?(consideration_journey_stage: 123_456_789)).to be false
    end
  end

  describe "#graduate?" do
    it "returns true for degree_status 222750000" do
      expect(graduate?(degree_status: 222_750_000)).to be true
    end

    it "returns false for other degree_status values" do
      expect(graduate?(degree_status: 123_456_789)).to be false
    end
  end

  describe "#studying?" do
    it "returns true for degree_status 222750006" do
      expect(studying?(degree_status: 222_750_006)).to be true
    end

    it "returns false for other degree_status values" do
      expect(studying?(degree_status: 123_456_789)).to be false
    end
  end

  describe "#no_degree?" do
    it "returns true for degree_status 222750004" do
      expect(no_degree?(degree_status: 222_750_004)).to be true
    end

    it "returns false for other degree_status values" do
      expect(no_degree?(degree_status: 123_456_789)).to be false
    end
  end

  describe "#consideration_journey_stage_id" do
    before do
      allow(session).to receive(:dig).with("mailinglist", "consideration_journey_stage_id").and_return(nil)
      consideration_journey_stage_id
    end

    specify "checks the welcome guide and mailing list session values" do
      expect(session).to have_received(:dig).with("mailinglist", "consideration_journey_stage_id")
    end
  end
end
