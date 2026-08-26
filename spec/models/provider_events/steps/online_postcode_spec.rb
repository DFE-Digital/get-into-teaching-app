require "rails_helper"

RSpec.describe ProviderEvents::Steps::OnlinePostcode do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"
  it_behaves_like "a normalised and validated postcode", :online_postcode, "Enter a full UK postcode"

  it { is_expected.to validate_presence_of :online_postcode }
  it { is_expected.to validate_length_of(:online_postcode).is_at_most(10) }

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:event_type) { instance_double(ProviderEvents::Steps::EventType, in_person?: in_person) }
    end

    context "when in-person" do
      let(:in_person) { true }

      it { is_expected.to be_skipped }
    end

    context "when not in-person" do
      let(:in_person) { false }

      it { is_expected.not_to be_skipped }
    end
  end
end
