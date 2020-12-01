require "rails_helper"

RSpec.describe Cards::LatestEventComponent, type: :component do
  subject { render_inline(instance) && page }

  let(:url_helpers) { Rails.application.routes.url_helpers }
  let(:event) { build(:event_api, name: "Test event") }
  let(:page_data) { double Pages::Data, latest_event_for_category: event }
  let(:instance) { described_class.new card: card, page_data: page_data }
  let(:card) { { category: "train to teach event" }.with_indifferent_access }

  before do
    expect(page_data).to \
      receive(:latest_event_for_category).with("train to teach event")
  end

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.to have_css ".card header", text: event.name }
  it { is_expected.to have_css "img" }
  it { is_expected.to have_content event.summary }

  it "includes the footer link" do
    is_expected.to have_link \
      "View event",
      href: url_helpers.event_path(event.readable_id),
      class: "git-link"
  end
end
