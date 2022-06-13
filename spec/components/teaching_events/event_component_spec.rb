require "rails_helper"

describe TeachingEvents::EventComponent, type: "component" do
  let(:event) { build(:event_api) }

  describe "methods" do
    let(:subject) { described_class.new(event: event) }

    describe "#train_to_teach?" do
      context "when the event is a TTT event" do
        let(:event) { build(:event_api) }

        it { expect(subject.train_to_teach?).to be(true) }
      end

      context "when the event is a question time event" do
        let(:event) { build(:event_api, :question_time_event) }

        it { expect(subject.train_to_teach?).to be(true) }
      end

      context "when the event is not a TTT event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        it { expect(subject.train_to_teach?).to be(false) }
      end
    end

    describe "#provider_event?" do
      context "when the event is a school and university event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        it { expect(subject.provider_event?).to be(true) }
      end

      context "when the event is a train to teach event" do
        let(:event) { build(:event_api) }

        it { expect(subject.provider_event?).to be(false) }
      end
    end

    describe "#online?" do
      context "when the event is marked online and not virtual" do
        let(:event) { build(:event_api, is_online: true, is_virtual: false) }

        it { expect(subject).to be_online }
      end

      context "when the event has a location and is not online" do
        let(:event) { build(:event_api, is_online: false) }

        it { expect(subject).to be_in_person }
      end

      # this is the new 'virtual', event has an address/building but nobody's invited!
      context "when the event has a location and is online" do
        let(:event) { build(:event_api, is_online: true) }

        it { expect(subject).not_to be_in_person }
      end

      context "when the event has no location" do
        let(:event) { build(:event_api, :no_location) }

        it { expect(subject).not_to be_in_person }
      end
    end

    describe "#in_person?" do
      context "when the event has a location" do
        let(:event) { build(:event_api) }

        it { expect(subject).to be_in_person }
      end

      context "when the event has no location" do
        let(:event) { build(:event_api, :no_location) }

        it { expect(subject).not_to be_in_person }
      end
    end

    describe "#classes" do
      context "when train to teach" do
        let(:event) { build(:event_api) }

        it { expect(subject.classes).to eql("event event--train-to-teach") }
      end

      context "when not train to teach" do
        let(:event) { build(:event_api, :online_event) }

        it { expect(subject.classes).to eql("event event--regular") }
      end

      context "when training provider" do
        let(:event) { build(:event_api, :school_or_university_event) }

        it { expect(subject.classes).to eql("event event--regular event--training-provider") }
      end
    end
  end

  describe "rendering" do
    let(:event) { build(:event_api) }

    before { render_inline(described_class.new(event: event)) }

    subject { page }

    specify "renders a list item" do
      expect(subject).to have_css("li.event")
    end

    context "when a train to teach event" do
      it { expect(subject).to have_css("li.event.event--train-to-teach") }

      specify "contains the event name as a link" do
        expect(subject).to have_link(event.name, href: "/events/#{event.readable_id}")
      end

      specify "contains the date and time" do
        expect(subject).to have_css(".event__info__date-and-time", text: event.start_at.to_formatted_s(:event))
        expect(subject).to have_css(".event__info__date-and-time", text: event.start_at.to_formatted_s(:time))
      end

      context "when in person" do
        it { expect(subject).to have_css("div.event__info__setting.in-person", text: "In person") }
      end

      context "when not in person" do
        let(:event) { build(:event_api, :no_location) }

        it { expect(subject).not_to have_css("div.event__info__setting.in-person") }
      end

      context "when online" do
        let(:event) { build(:event_api, is_online: true) }

        it { expect(subject).to have_css("div.event__info__setting.online", text: "Online") }
      end

      context "when not online" do
        let(:event) { build(:event_api, is_online: false, is_virtual: false) }

        it { expect(subject).not_to have_css("div.event__info__setting.online") }
      end
    end

    context "when a regular event" do
      let(:event) { build(:event_api, :school_or_university_event) }

      it { expect(subject).to have_css("li.event.event--regular") }

      specify "contains the event name as a link" do
        expect(subject).to have_link(event.name, href: "/events/#{event.readable_id}")
      end

      specify "contains the date and time" do
        expect(subject).to have_css(".event__top-bar--left", text: event.start_at.to_formatted_s(:event))
        expect(subject).to have_css(".event__top-bar--left", text: event.start_at.to_formatted_s(:time))
      end

      context "when in person" do
        let(:event) { build(:event_api, :school_or_university_event) }

        it { expect(subject).to have_css("div.event__bottom-bar--left__setting.in-person", text: "In person") }
      end

      context "when not in person" do
        let(:event) { build(:event_api, :school_or_university_event, :no_location) }

        it { expect(subject).not_to have_css("div.event__bottom-bar--left__setting.in-person") }
      end

      context "when online" do
        let(:event) { build(:event_api, :school_or_university_event, is_online: true) }

        it { expect(subject).to have_css("div.event__bottom-bar--left__setting.online", text: "Online") }
      end

      context "when not online" do
        let(:event) { build(:event_api, :school_or_university_event, is_online: false, is_virtual: false) }

        it { expect(subject).not_to have_css("div.event__bottom-bar--left__setting.online") }
      end

      context "when school or university event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        specify "DfE logo is present" do
          expect(subject).not_to have_css(".event__bottom-bar--right")
        end
      end

      context "when non-school or university event" do
        let(:event) { build(:event_api, :online_event) }

        specify "DfE logo is present" do
          expect(subject).to have_css(".event__bottom-bar--right img.dfelogo")
        end
      end
    end
  end
end
