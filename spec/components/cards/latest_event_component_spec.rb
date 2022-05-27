require "rails_helper"

RSpec.describe Cards::LatestEventComponent, type: :component do
  subject { render_inline(instance) && page }

  let(:page_data) { Pages::Data.new }
  let(:url_helpers) { Rails.application.routes.url_helpers }
  let(:event) { build(:event_api, name: "Test event") }
  let(:instance) { described_class.new card: card, page_data: page_data }
  let(:card) { { "category" => "train to teach event" } }
  let(:find_events_header) { Cards::FindEventsComponent::HEADER }

  context "with category" do
    before do
      allow(page_data).to receive(:latest_event_for_category)
        .with("train to teach event")
        .and_return event
    end

    context "with events" do
      it { is_expected.to have_css ".card" }
      it { is_expected.to have_css ".card.card--no-border" }
      it { is_expected.to have_css ".card header", text: event.name }
      it { is_expected.to have_css "img[alt='A photograph of staff chatting in a school setting']" }
      it { is_expected.to have_content event.summary }

      it "includes the footer link" do
        is_expected.to have_link \
          "View event",
          href: url_helpers.event_path(event.readable_id),
          class: "link--chevron"
      end
    end

    context "with no events" do
      let(:event) { nil }

      it { is_expected.to have_css ".card header", text: find_events_header }
      it { is_expected.to have_link "View events", href: url_helpers.events_path }
    end
  end

  context "with unknown category" do
    include_context "with stubbed types api"

    let(:card) { { "category" => "unknown" } }

    before { allow(Sentry).to receive(:capture_exception).and_call_original }

    it { is_expected.to have_css ".card header", text: find_events_header }
  end

  context "with no category" do
    include_context "with stubbed types api"

    let(:card) { {} }

    before { allow(Sentry).to receive(:capture_exception).and_call_original }

    it { is_expected.to have_css ".card header", text: find_events_header }
  end
end
