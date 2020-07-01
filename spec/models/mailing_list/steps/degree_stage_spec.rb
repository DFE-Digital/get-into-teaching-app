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
end
