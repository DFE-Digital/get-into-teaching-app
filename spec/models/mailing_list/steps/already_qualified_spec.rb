require "rails_helper"

describe MailingList::Steps::AlreadyQualified do
  include_context "with wizard step"
  let(:wizard) { MailingList::Wizard.new(wizardstore, described_class.key) }

  before do
    allow(instance).to receive(:other_step).with(:life_stage) { instance_double(MailingList::Steps::LifeStage, qualified_teacher?: qualified_teacher) }
  end

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  context "when a qualified teacher" do
    let(:qualified_teacher) { true }

    it "is not skipped when already qualified to teach" do
      is_expected.not_to be_skipped
    end
  end

  context "when not a qualified teacher" do
    let(:qualified_teacher) { false }

    it "is not skipped when already qualified to teach" do
      is_expected.to be_skipped
    end
  end
end
