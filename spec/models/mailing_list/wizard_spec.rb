require "rails_helper"

describe MailingList::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        MailingList::Steps::Name,
        MailingList::Steps::DegreeStage,
        MailingList::Steps::TeacherTraining,
        MailingList::Steps::Subject,
        MailingList::Steps::Postcode,
        MailingList::Steps::Contact,
      ]
    end
  end

  describe "#complete!" do
    let(:store) { { "first_name" => "Joe", "last_name" => "Joeseph" } }
    let(:wizardstore) { Wizard::Store.new store }
    subject { described_class.new wizardstore, "contact" }
    before { allow(subject).to receive(:valid?).and_return true }
    before { subject.complete! }

    it { is_expected.to have_received(:valid?) }
    it { expect(store).to eql({}) }
  end
end
