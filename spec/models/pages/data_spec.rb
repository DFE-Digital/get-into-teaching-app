require "rails_helper"

RSpec.describe Pages::Data do
  include_context "with fixture markdown pages"

  let(:instance) { described_class.new }

  describe "#find_page" do
    include_context "with fixture markdown pages"

    subject { instance.find_page "/page1" }

    it { is_expected.to include title: "Hello World 1 Upwards" }
  end

  describe "#latest_event_for_category" do
    include_context "with stubbed types api"
    include_context "with stubbed upcoming events by category api", 1

    subject { instance.latest_event_for_category category }

    context "with category id" do
      let(:category) { 222_750_001 }

      it { is_expected.to be_kind_of GetIntoTeachingApiClient::TeachingEvent }
      it { is_expected.to have_attributes type_id: category }
    end

    context "with category name" do
      let(:category) { "Train to Teach event" }

      it { is_expected.to be_kind_of GetIntoTeachingApiClient::TeachingEvent }
      it { is_expected.to have_attributes type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES[category] }
    end
  end

  describe "#featured_page" do
    subject { instance.featured_page }

    before { expect(Pages::Page).to receive(:featured).and_call_original }

    it { is_expected.to be_kind_of Pages::Page }
  end
end
