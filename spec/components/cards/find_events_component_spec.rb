require "rails_helper"

RSpec.describe Cards::FindEventsComponent, type: :component do
  subject { render_inline(instance) && page }

  let(:page_data) { Pages::Data.new }
  let(:url_helpers) { Rails.application.routes.url_helpers }
  let(:event) { build(:event_api, name: "Test event") }
  let(:card) { {} }
  let(:instance) { described_class.new card: card, page_data: page_data }

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.to have_css ".card header", text: described_class::HEADER }
  it { is_expected.to have_css "img[alt='A photograph of staff chatting in a school setting']" }
  it { is_expected.to have_content described_class::SNIPPET }

  it "includes the footer link" do
    is_expected.to have_link \
      "View events",
      href: url_helpers.events_path,
      class: "link--chevron"
  end
end
