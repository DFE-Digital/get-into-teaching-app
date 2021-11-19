require "rails_helper"

describe "Circuit breaker", type: :request do
  let(:error) { GetIntoTeachingApiClient::CircuitBrokenError }

  before do
    api_constants = GetIntoTeachingApiClient.constants.select { |klass| klass.to_s.end_with?("Api") }
    apis_to_mock = api_constants.map { |const| GetIntoTeachingApiClient.const_get(const) }
    apis_to_mock.each do |api|
      api.instance_methods(false).each do |method|
        allow_any_instance_of(api).to receive(method).and_raise(error)
      end
    end
  end

  context "when the API returns a CircuitBrokenError" do
    before { allow(Sentry).to receive(:capture_exception).with(error) }

    it "the EventsController redirects to an error page" do
      get event_path("event-id")
      expect(response).to redirect_to(events_not_available_path)
    end

    it "the EventCategoriesController redirects to an error page" do
      get event_category_path("category-id")
      expect(response).to redirect_to(events_not_available_path)
    end

    it "the EventStepsController redirects to an error page" do
      get event_step_path("event-id", "privacy_policy")
      expect(response).to redirect_to(events_not_available_path)
    end

    it "the MailingList::StepsController redirects to an error page" do
      get mailing_list_step_path("privacy_policy")
      expect(response).to redirect_to(mailinglist_not_available_path)
    end

    it "the Callbacks::StepsController redirects to an error page" do
      get callbacks_step_path("privacy_policy")
      expect(response).to redirect_to(callbacks_not_available_path)
    end
  end
end
