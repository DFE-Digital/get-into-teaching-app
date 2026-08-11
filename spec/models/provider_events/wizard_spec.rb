require "rails_helper"

RSpec.describe ProviderEvents::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it {
      is_expected.to eql [
        ProviderEvents::Steps::Email,
        ProviderEvents::Steps::EventName,
        ProviderEvents::Steps::EventDescription,
        ProviderEvents::Steps::OrganisationName,
        ProviderEvents::Steps::EventWebsite,
        ProviderEvents::Steps::TargetAudience,
        ProviderEvents::Steps::EventDate,
        ProviderEvents::Steps::EventTimes,
        ProviderEvents::Steps::EventType,
        ProviderEvents::Steps::OnlinePostcode,
        ProviderEvents::Steps::InPersonLocation,
        ProviderEvents::Steps::NewVenue,
        ProviderEvents::Steps::RegistrationDetails,
        ProviderEvents::Steps::ReviewAnswers,
      ]
    }
  end

  describe "#complete!" do
    subject { described_class.new(wizardstore, current_step) }

    let(:wizardstore) { GITWizard::Store.new store[uuid], {} }
    let(:uuid) { SecureRandom.uuid }
    let(:store) do
      { uuid => {
        "email" => "email@address.com",
        "description" => "Event Description",
        "organisation_name" => "Organisation Name",
      } }
    end
    let(:current_step) { "review_answers" }

    before do
      allow(subject).to receive(:valid?).and_return(true)
    end

    context "with prune! spy" do
      before { allow(wizardstore).to receive(:prune!) }

      it "prunes the store, retaining certain attributes" do
        subject.complete!
        expect(wizardstore).to have_received(:prune!).with({ leave: %w[email reference_number] }).once
      end
    end

    it "checks the wizard is valid" do
      subject.complete!
      is_expected.to have_received(:valid?)
    end

    it "prunes the store, retaining certain attributes" do
      subject.complete!
      expect(store[uuid]).to eql({
        "email" => "email@address.com",
        "reference_number" => "COMING-SOON",
      })
    end
  end
end
