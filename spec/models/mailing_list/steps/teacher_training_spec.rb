require "rails_helper"

describe MailingList::Steps::TeacherTraining do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :teacher_training }

  context "teacher_training" do
    let(:statuses) { described_class.statuses }
    it { is_expected.to allow_value(statuses.first).for :teacher_training }
    it { is_expected.to allow_value(statuses.last).for :teacher_training }
    it { is_expected.not_to allow_value(nil).for :teacher_training }
    it { is_expected.not_to allow_value("").for :teacher_training }
    it { is_expected.not_to allow_value("random").for :teacher_training }
  end
end
