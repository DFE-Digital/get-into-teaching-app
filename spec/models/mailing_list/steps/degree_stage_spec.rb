require "rails_helper"

describe MailingList::Steps::DegreeStage do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :degree_stage }

  context "degree_stage" do
    let(:stages) { described_class.stages }
    it { is_expected.to allow_value(stages.first).for :degree_stage }
    it { is_expected.to allow_value(stages.last).for :degree_stage }
    it { is_expected.not_to allow_value(nil).for :degree_stage }
    it { is_expected.not_to allow_value("").for :degree_stage }
    it { is_expected.not_to allow_value("random").for :degree_stage }
  end

  context "skipped?" do
    subject { described_class.new nil, Wizard::Store.new(store), {} }

    context "when describe_yourself_option_id equals 'Student'" do
      let(:store) { { "describe_yourself_option_id" => GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Student"] } }
      it { is_expected.to have_attributes skipped?: false }
    end

    context "when describe_yourself_option_id does not equal student" do
      let(:store) { { "describe_yourself_option_id" => GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Looking to change career"] } }
      it { is_expected.to have_attributes skipped?: true }
    end

    context "when describe_yourself_option_id is not set" do
      let(:store) { {} }
      it { is_expected.to have_attributes skipped?: true }
    end
  end
end
