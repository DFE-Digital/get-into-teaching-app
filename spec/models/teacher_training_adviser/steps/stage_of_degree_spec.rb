require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StageOfDegree do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  it_behaves_like "a wizard step that exposes API pick list items as options",
                  :get_qualification_degree_status, nil, described_class::DEGREE_STATUS.values

  describe "attributes" do
    it { is_expected.to respond_to :degree_status_id }
  end

  describe "#degree_status_id" do
    it "allows a valid degree status id" do
      status = GetIntoTeachingApiClient::PickListItem.new(id: 123)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_qualification_degree_status) { [status] }
      expect(subject).to allow_value(status.id).for :degree_status_id
    end

    it { is_expected.not_to allow_values("", nil, 456).for :degree_status_id }
  end

  describe "#final_year?" do
    context "when degree_status_id is not yet set" do
      before { wizardstore["degree_status_id"] = nil }

      it { is_expected.not_to be_final_year }
    end

    context "when degree_status_id is not 222_750_001 (not final year)" do
      before { wizardstore["degree_status_id"] = 222_750_002 }

      it { is_expected.not_to be_final_year }
    end

    context "when degree_status_id is 222_750_001 (final year)" do
      before { wizardstore["degree_status_id"] = 222_750_001 }

      it { is_expected.to be_final_year }
    end
  end

  describe "#skipped?" do
    it "returns false if HaveADegree step was shown and they are studying for a degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
      expect(subject).not_to be_skipped
    end

    it "returns true if HaveADegree was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if not studying for a degree" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:pick_list_item) { GetIntoTeachingApiClient::PickListItem.new(id: 222_750_002, value: "Second year") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_qualification_degree_status) { [pick_list_item] }
      instance.degree_status_id = pick_list_item.id
    end

    it { is_expected.to eq({ "degree_status_id" => "Second year" }) }
  end
end
