require "rails_helper"

RSpec.feature "Register a provider event", type: :feature do
  include_context "with wizard data"

  describe "Registering an online event" do
    before { visit provider_events_steps_path }

    it "navigates the steps" do
      expect(page).to have_link(href: provider_events_step_path(ProviderEvents::Steps::Email.key))
      click_on "Start now"

      expect(page).to have_field("What is your email address?")
      fill_in "What is your email address?", with: "test@test.test"
      click_on "Next step"

      expect(page).to have_field("What is the name of your event?")
      fill_in "What is the name of your event?", with: "Super-duper Event"
      click_on "Next step"

      expect(page).to have_field("Describe your event")
      fill_in "Describe your event", with: "Lorem ipsum dolor sit amet"
      click_on "Next step"

      expect(page).to have_field("What is the name of your organisation?")
      fill_in "What is the name of your organisation?", with: "Training Organisation"
      click_on "Next step"

      expect(page).to have_field("Provide your website URL")
      fill_in "Provide your website URL", with: "https://www.example.com"
      click_on "Next step"

      expect(page).to have_field("Who is this event for?")
      fill_in "Who is this event for?", with: "Trainee teachers"
      click_on "Next step"

      expect(page).to have_field("What day is your event?")
      fill_in "What day is your event", with: "30/12/3000"
      click_on "Next step"

      expect(page).to have_content("What time does your event start and end?")
      within_fieldset("Start at") do
        fill_in "Hour", with: 13
        fill_in "Minute", with: 0
      end
      within_fieldset("End at") do
        fill_in "Hour", with: 17
        fill_in "Minute", with: 30
      end
      click_on "Next step"

      expect(page).to have_content("What type of event is this?")
      within_fieldset("What type of event is this?") do
        choose "Online"
      end
      click_on "Next step"

      expect(page).to have_field("Provide a postcode for your event")
      fill_in "Provide a postcode for your event", with: "Te57 1nG"
      click_on "Next step"

      expect(page).to have_content("How will people register for your event?")
      within_fieldset("How will people register for your event?") do
        choose "Through a website"
        fill_in "Website URL", with: "https://www.example.com/register"
      end
      click_on "Next step"

      expect(page).to have_content("Check your answers before you submit your event details")

      expect(page).to have_content("What is your email address?")
      expect(page).to have_content("test@test.test")
      expect(page).to have_content("What is the name of your event?")
      expect(page).to have_content("Super-duper Event")
      expect(page).to have_content("Describe your event")
      expect(page).to have_content("Lorem ipsum dolor sit amet")
      expect(page).to have_content("What is the name of your organisation?")
      expect(page).to have_content("Training Organisation")
      expect(page).to have_content("Provide your website URL")
      expect(page).to have_content("https://www.example.com")
      expect(page).to have_content("Who is this event for?")
      expect(page).to have_content("Trainee teachers")
      expect(page).to have_content("What day is your event?")
      expect(page).to have_content("30 December 3000")
      expect(page).to have_content("What time does your event start and end?")
      expect(page).to have_content("13:00 - 17:30")
      expect(page).to have_content("What type of event is this?")
      expect(page).to have_content("Online")
      expect(page).to have_content("Provide a postcode for your event")
      expect(page).to have_content("TE57 1NG")
      expect(page).to have_content("How will people register for your event?")
      expect(page).to have_content("https://www.example.com/register")
      click_on "Next step"

      expect(page).to have_content("Application submitted")
      expect(page).to have_content("test@test.test")
    end

    describe "Registering an in-person event" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi).to receive(:get_teaching_event_buildings).and_return(buildings)
        visit provider_events_steps_path
      end

      let(:buildings) { build_list(:event_building, 1) }

      it "navigates the steps" do
        expect(page).to have_link(href: provider_events_step_path(ProviderEvents::Steps::Email.key))
        click_on "Start now"

        expect(page).to have_field("What is your email address?")
        fill_in "What is your email address?", with: "test@test.test"
        click_on "Next step"

        expect(page).to have_field("What is the name of your event?")
        fill_in "What is the name of your event?", with: "Super-duper Event"
        click_on "Next step"

        expect(page).to have_field("Describe your event")
        fill_in "Describe your event", with: "Lorem ipsum dolor sit amet"
        click_on "Next step"

        expect(page).to have_field("What is the name of your organisation?")
        fill_in "What is the name of your organisation?", with: "Training Organisation"
        click_on "Next step"

        expect(page).to have_field("Provide your website URL")
        fill_in "Provide your website URL", with: "https://www.example.com"
        click_on "Next step"

        expect(page).to have_field("Who is this event for?")
        fill_in "Who is this event for?", with: "Lorem ipsum dolor sit amet"
        click_on "Next step"

        expect(page).to have_field("What day is your event?")
        fill_in "What day is your event", with: "30/12/3000"
        click_on "Next step"

        expect(page).to have_content("What time does your event start and end?")
        within_fieldset("Start at") do
          fill_in "Hour", with: 13
          fill_in "Minute", with: 0
        end
        within_fieldset("End at") do
          fill_in "Hour", with: 17
          fill_in "Minute", with: 30
        end
        click_on "Next step"

        expect(page).to have_content("What type of event is this?")
        within_fieldset("What type of event is this?") do
          choose "In-person"
        end
        click_on "Next step"

        expect(page).to have_content("Where will your event be?")
        within_fieldset("Where will your event be?") do
          choose "Search existing venues"
          select "test, M1 7AX", from: "Search for existing buildings"
        end
        click_on "Next step"

        expect(page).to have_content("How will people register for your event?")
        within_fieldset("How will people register for your event?") do
          choose "Through a website"
          fill_in "Website URL", with: "https://www.example.com/"
        end
        click_on "Next step"

        expect(page).to have_content("Check your answers before you submit your event details")
        expect(page).to have_content("What type of event is this?")
        expect(page).to have_content("In-person")
        expect(page).to have_content("Where will your event be?")
        expect(page).to have_content("test (M1 7AX)")
        click_on "Next step"

        expect(page).to have_content("Application submitted")
        expect(page).to have_content("test@test.test")
      end

      describe "Registering an in-person event at a new venue" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi).to receive(:get_teaching_event_buildings).and_return(buildings)
          visit provider_events_steps_path
        end

        let(:buildings) { build_list(:event_building, 1) }

        it "navigates the steps" do
          expect(page).to have_link(href: provider_events_step_path(ProviderEvents::Steps::Email.key))
          click_on "Start now"

          expect(page).to have_field("What is your email address?")
          fill_in "What is your email address?", with: "test@test.test"
          click_on "Next step"

          expect(page).to have_field("What is the name of your event?")
          fill_in "What is the name of your event?", with: "Super-duper Event"
          click_on "Next step"

          expect(page).to have_field("Describe your event")
          fill_in "Describe your event", with: "Lorem ipsum dolor sit amet"
          click_on "Next step"

          expect(page).to have_field("What is the name of your organisation?")
          fill_in "What is the name of your organisation?", with: "Training Organisation"
          click_on "Next step"

          expect(page).to have_field("Provide your website URL")
          fill_in "Provide your website URL", with: "https://www.example.com"
          click_on "Next step"

          expect(page).to have_field("Who is this event for?")
          fill_in "Who is this event for?", with: "Lorem ipsum dolor sit amet"
          click_on "Next step"

          expect(page).to have_field("What day is your event?")
          fill_in "What day is your event", with: "30/12/3000"
          click_on "Next step"

          expect(page).to have_content("What time does your event start and end?")
          within_fieldset("Start at") do
            fill_in "Hour", with: 13
            fill_in "Minute", with: 0
          end
          within_fieldset("End at") do
            fill_in "Hour", with: 17
            fill_in "Minute", with: 30
          end
          click_on "Next step"

          expect(page).to have_content("What type of event is this?")
          within_fieldset("What type of event is this?") do
            choose "In-person"
          end
          click_on "Next step"

          expect(page).to have_content("Where will your event be?")
          within_fieldset("Where will your event be?") do
            choose "Add a new venue"
          end
          click_on "Next step"

          expect(page).to have_content("Venue details")
          fill_in "Venue name", with: "Womble HQ"
          fill_in "Address line 1", with: "Wimbledon Common"
          fill_in "Address line 2", with: "Wimbledon"
          fill_in "Address line 3", with: "Merton"
          fill_in "Town or city", with: "London"
          fill_in "Postcode", with: "TE57 1NG"
          click_on "Next step"

          expect(page).to have_content("How will people register for your event?")
          within_fieldset("How will people register for your event?") do
            choose "Through a website"
            fill_in "Website URL", with: "https://www.example.com/"
          end
          click_on "Next step"

          expect(page).to have_content("Check your answers before you submit your event details")
          expect(page).to have_content("What type of event is this?")
          expect(page).to have_content("In-person")
          expect(page).to have_content("Where will your event be?")
          expect(page).to have_content("Womble HQ, Wimbledon Common, Wimbledon, Merton, London, TE57 1NG")
          click_on "Next step"

          expect(page).to have_content("Application submitted")
          expect(page).to have_content("test@test.test")
        end
      end
    end
  end
end
