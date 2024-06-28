require "rails_helper"

describe "Rate limiting", type: :request do
  include_context "with stubbed types api"
  include_context "with stubbed candidate create access token api"

  let(:ip) { "1.2.3.4" }

  it_behaves_like "an IP-based rate limited endpoint", "POST /csp_reports", 5, 1.minute do
    def perform_request
      post csp_reports_path, params: {}.to_json, headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "PATCH /mailinglist/signup/name", 5, 1.minute do
    def perform_request
      key = MailingList::Steps::Name.model_name.param_key
      params = { key => attributes_for(:mailing_list_name) }
      patch mailing_list_step_path(:name), params: params, headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "GET */resend_verification", 5, 1.minute do
    def perform_request
      get resend_verification_mailing_list_steps_path(redirect_path: "redirect/path"), headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "PATCH */mailinglist/signup/postcode", 5, 1.minute do
    def perform_request
      key = MailingList::Steps::Postcode.model_name.param_key
      params = { key => attributes_for(:mailing_list_postcode) }
      patch mailing_list_step_path(:postcode), params: params, headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "PATCH */mailinglist/signup/subject", 5, 1.minute do
    def perform_request
      key = MailingList::Steps::Subject.model_name.param_key
      params = { key => attributes_for(:mailing_list_subject) }
      patch mailing_list_step_path(:subject), params: params, headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "PATCH /teacher-training-adviser/sign_up/identity", 5, 1.minute do
    def perform_request
      key = TeacherTrainingAdviser::Steps::Identity.model_name.param_key
      params = { key => { first_name: "first", last_name: "last", email: "email@address.com" } }
      patch teacher_training_adviser_step_path(:identity), params: params, headers: { "REMOTE_ADDR" => ip }
    end
  end

  it_behaves_like "an IP-based rate limited endpoint", "PATCH */teacher-training-adviser/sign_up/review_answers", 5, 1.minute do
    def perform_request
      patch teacher_training_adviser_step_path(:review_answers), params: {}, headers: { "REMOTE_ADDR" => ip }
    end
  end

  describe "event endpoint rate limiting" do
    let(:readable_event_id) { "123" }

    before do
      event = build(:event_api, readable_id: readable_event_id)

      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:get_teaching_event).and_return event
    end

    it_behaves_like "an IP-based rate limited endpoint", "PATCH /events/:id/apply/personal_details", 5, 1.minute do
      def perform_request
        key = Events::Steps::PersonalDetails.model_name.param_key
        params = { key => attributes_for(:events_personal_details) }
        patch event_step_path(readable_event_id, :personal_details), params: params, headers: { "REMOTE_ADDR" => ip }
      end
    end

    it_behaves_like "an IP-based rate limited endpoint", "PATCH */events/:id/apply/personalised_updates", 5, 1.minute do
      def perform_request
        key = Events::Steps::PersonalisedUpdates.model_name.param_key
        params = { key => attributes_for(:events_personalised_updates) }
        patch event_step_path(readable_event_id, :personalised_updates), params: params, headers: { "REMOTE_ADDR" => ip }
      end
    end

    it_behaves_like "an IP-based rate limited endpoint", "PATCH */events/:id/apply/further_details", 5, 1.minute do
      def perform_request
        key = Events::Steps::FurtherDetails.model_name.param_key
        params = { key => attributes_for(:events_further_details) }
        patch event_step_path(readable_event_id, :further_details), params: params, headers: { "REMOTE_ADDR" => ip }
      end
    end
  end

  describe "event upsert endpoint rate limiting" do
    let(:event) { attributes_for(:internal_event, { "building": { "id": "" } }) }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upsert_teaching_event).and_return event
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
        .to receive(:get_teaching_event_buildings).and_return([])
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
        .to receive(:get_teaching_event).with(event[:id]) { build(:event_api) }

      allow_basic_auth_users([
        { username: "publisher", password: "password1", role: "publisher" },
        { username: "author", password: "password2", role: "author" },
      ])
    end

    it_behaves_like "an IP-based rate limited endpoint", "POST /internal/events", 10, 20.seconds do
      def perform_request
        post internal_events_path,
             headers: { "REMOTE_ADDR" => ip }.merge(basic_auth_headers("author", "password2")),
             params: { internal_event: event }
      end
    end

    it_behaves_like "an IP-based rate limited endpoint", "PUT /internal/approve", 10, 20.seconds do
      let(:params) { { "id": event[:id] } }

      def perform_request
        put internal_approve_path,
            headers: { "REMOTE_ADDR" => ip }.merge(basic_auth_headers("publisher", "password2")),
            params: params
      end
    end
  end
end
