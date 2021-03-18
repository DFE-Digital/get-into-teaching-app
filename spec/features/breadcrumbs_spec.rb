require "rails_helper"

RSpec.feature "Breadcrumbs", type: :feature do
  include_context "stub types api"

  let(:event) { GetIntoTeachingApiClient::TeachingEvent.new(statusId: 1) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { event }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { [] }
  end

  before { visit path }
  subject { page }

  context "when visiting the home page" do
    let(:path) { "/home-page" }

    it { is_expected.to_not have_css(".breadcrumb") }
  end

  context "when visiting a content page" do
    let(:path) { page_path("test/subfolder/nested") }

    it { is_expected.to have_css(".breadcrumb") }

    it "links to all ancestor pages" do
      page.within ".breadcrumb" do
        is_expected.to have_link "Subfolder", href: "/test/subfolder"
        is_expected.to have_link "Test", href: "/test"
        is_expected.to have_link "Home", href: "/"
      end
    end
  end

  context "when visiting a content page without a title" do
    let(:path) { page_path("no-title") }

    it { is_expected.to have_http_status(:success) }
  end

  context "when visiting a disclaimer page" do
    let(:path) { page_path("disclaimer") }

    it { is_expected.to have_css(".breadcrumb") }
  end

  context "when visiting the stories landing page" do
    let(:path) { page_path("stories/landing-page") }

    it { is_expected.to have_css(".breadcrumb") }
  end

  context "when visiting the story listing page" do
    let(:path) { page_path("stories/list-page") }

    it { is_expected.to have_css(".breadcrumb") }
  end

  context "when visiting the story page" do
    let(:path) { page_path("stories/story-page") }

    it { is_expected.to have_css(".breadcrumb") }
  end

  context "when visiting the mailing list sign up page" do
    let(:path) { mailing_list_steps_path }

    it { is_expected.not_to have_css(".breadcrumb") }
  end

  context "when visiting the event sign up page" do
    let(:path) { event_steps_path("123") }

    it { is_expected.not_to have_css(".breadcrumb") }
  end

  context "when visiting an event category" do
    let(:path) { event_category_path("online-events") }

    it { is_expected.to have_css(".breadcrumb") }
  end
end
