require "rails_helper"

RSpec.describe Events::Category do
  include_context "with stubbed types api"

  let(:category_name) { "Train to Teach event" }
  let(:type_id) do
    EventType.lookup_by_name(category_name)
  end

  describe "#new" do
    context "with id" do
      subject { described_class.new type_id }

      it { is_expected.to be_kind_of described_class }
      it { is_expected.to have_attributes id: type_id }

      it "will raise an error with an unknown id" do
        expect { described_class.new 10 }.to \
          raise_exception Events::Category::UnknownEventCategory
      end
    end

    context "with name" do
      subject { described_class.new category_name }

      it { is_expected.to be_kind_of described_class }
      it { is_expected.to have_attributes id: type_id }

      it "will raise an error with an unknown id" do
        expect { described_class.new "Unknown event type" }.to \
          raise_exception Events::Category::UnknownEventCategory
      end

      context "with incorrect case" do
        subject { described_class.new "train to teach events" }

        it { is_expected.to be_kind_of described_class }
        it { is_expected.to have_attributes id: type_id }
      end
    end
  end

  describe "#latest" do
    include_context "with stubbed upcoming events by category api", 1

    subject { instance.latest }

    let(:instance) { described_class.new type_id }
    let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }

    it { is_expected.to be_kind_of GetIntoTeachingApiClient::TeachingEvent }
    it { is_expected.to have_attributes type_id: type_id }

    context "with no events for category id" do
      let(:category_name) { "Online event" }

      it { is_expected.to be_nil }
    end
  end
end
