require "rails_helper"

RSpec.describe ProviderEvents::Steps::OnlinePostcode do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :online_postcode }

  it { is_expected.to validate_presence_of :online_postcode }

  it { is_expected.to validate_length_of(:online_postcode).is_at_most(10) }

  describe "validations for online_postcode" do
    it { is_expected.to allow_value("TE57 1NG").for :online_postcode }
    it { is_expected.to allow_value("  TE571NG  ").for :online_postcode }
    it { is_expected.to allow_value("  Te571nG  ").for :online_postcode }
    it { is_expected.not_to allow_value(nil).for(:online_postcode).with_message("Enter postcode") }
    it { is_expected.not_to allow_value("").for(:online_postcode).with_message("Enter postcode") }
    it { is_expected.not_to allow_value("random").for(:online_postcode).with_message("Enter a full UK postcode") }
    it { is_expected.not_to allow_value("TE57 ING").for(:online_postcode).with_message("Enter a full UK postcode") }
  end

  describe "normalise_postcode" do
    before do
      subject.online_postcode = postcode
      subject.valid?
    end

    context "when the postcode is in lowercase" do
      let(:postcode) { "wc1n 1ab" }

      it { expect(subject.online_postcode).to eq("WC1N 1AB") }
    end

    context "when the postcode has whitespace" do
      let(:postcode) { " wc1n 1ab " }

      it { expect(subject.online_postcode).to eq("WC1N 1AB") }
    end
  end

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
