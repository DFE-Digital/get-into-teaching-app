require "rails_helper"

describe "Rate limiting" do
  include_context "stub types api"
  include_context "stub candidate create access token api"

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

  it_behaves_like "an IP-based rate limited endpoint", "PATCH */mailinglist/signup/privacy_policy", 5, 1.minute do
    def perform_request
      key = MailingList::Steps::PrivacyPolicy.model_name.param_key
      params = { key => attributes_for(:mailing_list_privacy_policy) }
      patch mailing_list_step_path(:privacy_policy), params: params, headers: { "REMOTE_ADDR" => ip }
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
end
