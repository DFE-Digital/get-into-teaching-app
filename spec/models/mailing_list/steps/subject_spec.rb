require "rails_helper"

describe MailingList::Steps::Subject do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :subject }

  context "subject" do
    let(:subjects) { described_class.subjects }
    it { is_expected.to allow_value(subjects.first).for :subject }
    it { is_expected.to allow_value(subjects.last).for :subject }
    it { is_expected.not_to allow_value(nil).for :subject }
    it { is_expected.not_to allow_value("").for :subject }
    it { is_expected.not_to allow_value("random").for :subject }
  end
end
