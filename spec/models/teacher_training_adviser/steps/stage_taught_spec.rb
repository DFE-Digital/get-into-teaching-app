require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StageTaught do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  describe "attributes" do
    it { is_expected.to respond_to :stage_taught }
  end

  describe "#stage_taught" do
    it { is_expected.not_to allow_values("", nil, 123).for :stage_taught }
    it { is_expected.to allow_value("primary", "secondary").for :stage_taught }
  end

  describe "#previous_stage_primary?" do
    before do
      allow_any_instance_of(described_class).to \
        receive(:stage_taught) { returning_to_teaching }
    end

    context "when stage_taught is primary" do
      let(:stage_taught) { "primary" }

      it { is_expected.to be_previous_stage_primary }
    end

    context "when stage_taught is secondary" do
      let(:stage_taught) { "secondary" }

      it { is_expected.not_to be_previous_stage_primary }
    end
  end
end
