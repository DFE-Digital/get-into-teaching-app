require "rails_helper"

RSpec.describe Cards::RendererComponent, type: :component do
  subject { render_inline(instance) && page }

  let(:page_data) { Pages::Data.new }
  let(:instance) { described_class.new card: card, page_data: page_data }

  context "with no card type" do
    let(:card) { {} }

    it { is_expected.to have_css ".card" }
    it { is_expected.to have_css ".card.card--no-border" }

    it "will default to the chat online card" do
      is_expected.to have_content("Get the answers you need")
    end
  end

  context "with card type specified" do
    let(:card) { { "category" => "Train to Teach event", "card_type" => "latest_event" } }
    let(:event) { build(:event_api, name: "Test event") }
    let(:page_data) { instance_double(Pages::Data, latest_event_for_category: event) }

    it { is_expected.to have_css ".card" }
    it { is_expected.to have_css ".card.card--no-border" }
    it { is_expected.to have_css "img" }

    it { is_expected.to have_css ".card header", text: event.name }
  end

  context "with unknown card type specified" do
    let(:card) { { "card_type" => "random" } }

    it { expect { subject }.to raise_exception described_class::InvalidComponent }
  end

  context "with excluded type specified" do
    let(:card) { { "card_type" => "renderer" } }

    it { expect { subject }.to raise_exception described_class::InvalidComponent }
  end
end
