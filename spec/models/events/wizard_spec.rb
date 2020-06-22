require "rails_helper"

describe Events::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Events::Steps::PersonalDetails,
        Events::Steps::ContactDetails,
        Events::Steps::FurtherDetails,
      ]
    end
  end

  describe "#complete!" do
    let(:uuid) { SecureRandom.uuid }
    let(:store) { { uuid => { "first_name" => "Joe", "last_name" => "Joeseph" } } }
    let(:wizardstore) { Wizard::Store.new store[uuid] }
    subject { described_class.new wizardstore, "further_details" }
    before { allow(subject).to receive(:valid?).and_return true }
    before { subject.complete! }

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }
  end
end
