require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StageTaught do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.to be_skipped }

  describe "attributes" do
    it { is_expected.to respond_to :stage_taught_id }
  end

  describe "#stage_taught" do
    it { is_expected.not_to allow_values("", nil, 123, "primary", "secondary").for :stage_taught_id }
    it { is_expected.to allow_value(222_750_000, 222_750_001).for :stage_taught_id }
  end

  describe "#stage_taught_primary??" do
    before do
      allow_any_instance_of(described_class).to \
        receive(:stage_taught_id) { stage_taught_id }
    end

    context "when stage_taught is primary" do
      let(:stage_taught_id) { 222_750_000 }

      it { is_expected.to be_stage_taught_primary }
    end

    context "when stage_taught is secondary" do
      let(:stage_taught_id) { 222_750_001 }

      it { is_expected.not_to be_stage_taught_primary }
    end
  end
end
