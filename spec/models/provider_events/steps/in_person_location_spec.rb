require "rails_helper"

RSpec.describe ProviderEvents::Steps::InPersonLocation do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :location_option }
  it { is_expected.to respond_to :building }
  it { is_expected.to respond_to :existing? }
  it { is_expected.to respond_to :new? }

  it { is_expected.to validate_presence_of :location_option }
  it { is_expected.to validate_inclusion_of(:location_option).in_array(%w[existing new]) }

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:event_type) { instance_double(ProviderEvents::Steps::EventType, online?: online) }
    end

    context "when online" do
      let(:online) { true }

      it { is_expected.to be_skipped }
    end

    context "when not online" do
      let(:online) { false }

      it { is_expected.not_to be_skipped }
    end
  end

  describe "existing?" do
    subject { instance.existing? }

    before { instance.location_option = location_option }

    context "when nil" do
      let(:location_option) { nil }

      it { is_expected.to be false }
    end

    context "when existing" do
      let(:location_option) { "existing" }

      it { is_expected.to be true }
    end

    context "when new" do
      let(:location_option) { "new" }

      it { is_expected.to be false }
    end
  end

  describe "new?" do
    subject { instance.new? }

    before { instance.location_option = location_option }

    context "when nil" do
      let(:location_option) { nil }

      it { is_expected.to be false }
    end

    context "when existing" do
      let(:location_option) { "existing" }

      it { is_expected.to be false }
    end

    context "when new" do
      let(:location_option) { "new" }

      it { is_expected.to be true }
    end
  end
end
