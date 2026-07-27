require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventType do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :event_type }
  it { is_expected.to respond_to :is_in_person? }
  it { is_expected.to respond_to :is_online? }

  it { is_expected.to validate_presence_of :event_type }
  it { is_expected.to validate_inclusion_of(:event_type).in_array(['in_person','online']) }

  it { is_expected.not_to be_skipped }

  describe "is_in_person?" do
    subject { instance.is_in_person? }

    before { instance.event_type = event_type}

    context "when nil" do
      let(:event_type) { nil }

      it { is_expected.to be false }
    end

    context "when in-person" do
      let(:event_type) { "in_person" }

      it { is_expected.to be true }
    end

    context "when online" do
      let(:event_type) { "online" }

      it { is_expected.to be false }
    end
  end


  describe "is_online?" do
    subject { instance.is_online? }

    before { instance.event_type = event_type}

    context "when nil" do
      let(:event_type) { nil }

      it { is_expected.to be false }
    end

    context "when in-person" do
      let(:event_type) { "in_person" }

      it { is_expected.to be false }
    end

    context "when online" do
      let(:event_type) { "online" }

      it { is_expected.to be true }
    end
  end
end
