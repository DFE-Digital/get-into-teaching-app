require "rails_helper"

RSpec.feature "Breadcrumbs", type: :feature do
  include_context "with stubbed types api"

  subject { page }

  let(:event) { GetIntoTeachingApiClient::TeachingEvent.new(status_id: 1) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { event }

    visit path
  end

  context "when visiting the home page" do
    let(:path) { "/home-page" }

    it { is_expected.not_to have_css(".breadcrumbs") }
  end

  context "when visiting a content page" do
    let(:path) { page_path("test/subfolder/nested") }

    it { is_expected.to have_css(".breadcrumbs") }

    it "links to all ancestor pages and plain text of current page" do
      page.within ".breadcrumbs" do
        is_expected.to have_text "Nested Page Test"
        is_expected.to have_link "Subfolder", href: "/test/subfolder"
        is_expected.to have_link "Test", href: "/test"
        is_expected.to have_link "Home", href: "/"
      end
    end
  end

  context "when query params are present" do
    let(:path) { page_path("train-to-be-a-teacher", amazing: "yes") }

    it { is_expected.to have_css(".breadcrumbs") }

    it "includes the parent page" do
      page.within ".breadcrumbs" do
        is_expected.to have_link "Home", href: "/"
      end
    end

    it "includes the current page in plain text" do
      page.within ".breadcrumbs" do
        is_expected.not_to have_link "Train to be a teacher"
        is_expected.to have_text "Train to be a teacher"
      end
    end
  end

  context "when visiting a content page without a title" do
    let(:path) { page_path("no-title") }

    it { is_expected.to have_http_status(:success) }
  end

  context "when visiting a disclaimer page" do
    let(:path) { page_path("disclaimer") }

    it { is_expected.to have_css(".breadcrumbs") }
  end

  context "when visiting the stories landing page" do
    let(:path) { page_path("stories/landing-page") }

    it { is_expected.to have_css(".breadcrumbs") }
  end

  context "when visiting the story listing page" do
    let(:path) { page_path("stories/list-page") }

    it { is_expected.to have_css(".breadcrumbs") }
  end

  context "when visiting the story page" do
    let(:path) { page_path("stories/story-page") }

    it { is_expected.to have_css(".breadcrumbs") }
  end

  context "when visiting the mailing list sign up page" do
    let(:path) { mailing_list_steps_path }

    it { is_expected.not_to have_css(".breadcrumbs") }
  end

  context "when visiting the event sign up page" do
    let(:path) { event_steps_path("123") }

    it { is_expected.not_to have_css(".breadcrumbs") }
  end
end
