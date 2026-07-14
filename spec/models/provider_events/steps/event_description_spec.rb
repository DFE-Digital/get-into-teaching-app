require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventDescription do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :event_description }

  it { is_expected.to validate_presence_of :event_description }

  it { is_expected.to validate_length_of(:event_description).is_at_most(6000) }

  describe "event_description" do
    context "when there are more than 300 words" do
      let(:words) { ("word " * 301).strip }

      it { is_expected.not_to allow_values(words).for :event_description }
    end

    context "when there are at most 300 words" do
      let(:words) { ("word " * 300).strip }

      it { is_expected.to allow_values(words).for :event_description }
    end
  end

  it { is_expected.not_to be_skipped }
end
