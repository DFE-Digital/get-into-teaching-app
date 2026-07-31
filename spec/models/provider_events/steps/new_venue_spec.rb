require "rails_helper"

RSpec.describe ProviderEvents::Steps::NewVenue do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"
  it_behaves_like "a normalised and validated postcode", :address_postcode, "Enter a full UK postcode"

  it { is_expected.to respond_to :venue_name }
  it { is_expected.to respond_to :address_line_1 }
  it { is_expected.to respond_to :address_line_2 }
  it { is_expected.to respond_to :address_line_3 }
  it { is_expected.to respond_to :address_city }
  it { is_expected.to respond_to :address_postcode }

  it { is_expected.to validate_presence_of :venue_name }
  it { is_expected.to validate_presence_of :address_postcode }
  it { is_expected.to validate_length_of(:address_postcode).is_at_most(10) }

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:in_person_location) { instance_double(ProviderEvents::Steps::InPersonLocation, existing?: existing, skipped?: skipped) }
    end

    context "when in_person_location is skipped" do
      let(:skipped) { true }

      it { is_expected.to be_skipped }
    end

    context "when in_person_location is not skipped" do
      let(:skipped) { false }

      context "when existing location" do
        let(:existing) { true }

        it { is_expected.to be_skipped }
      end

      context "when a new location" do
        let(:existing) { false }

        it { is_expected.not_to be_skipped }
      end
    end
  end
end
