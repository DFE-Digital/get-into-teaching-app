require "rails_helper"

describe EventStepsController do
  include_context "stub types api"
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub event add attendee api"

  it_behaves_like "a controller with a #resend_verification action" do
    def perform_request
      get resend_verification_event_steps_path(readable_event_id, redirect_path: "redirect/path")
    end
  end

  let(:readable_event_id) { "123" }
  let(:model) { Events::Steps::PersonalDetails }
  let(:step_path) { event_step_path readable_event_id, model.key }
  let(:authenticate_path) { event_step_path(readable_event_id, "authenticate") }
  let(:event) { build :event_api, readable_id: readable_event_id }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(readable_event_id) { event }
  end

  describe "#index" do
    before { get event_steps_path("123", query: "param") }

    subject { response }

    it { is_expected.to redirect_to(event_step_path("123", { id: :personal_details, query: "param" })) }
  end

  describe "#show" do
    before { get step_path }

    subject { response }

    it { is_expected.to have_http_status :success }

    context "when the event is closed" do
      let(:event) { build :event_api, :closed, readable_id: readable_event_id }

      it { is_expected.to redirect_to(event_path(id: event.readable_id)) }

      context "when the candidate is a 'walk-in'" do
        let(:step_path) { event_step_path readable_event_id, model.key, walk_in: true }

        it { is_expected.to have_http_status :success }
      end
    end

    context "with an invalid step" do
      let(:step_path) { event_step_path readable_event_id, :invalid }

      it { is_expected.to have_http_status :not_found }
    end

    context "when the event does not exist" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).with("456")
          .and_raise(GetIntoTeachingApiClient::ApiError.new(code: 404))
      end

      before { get event_steps_path("456") }

      subject { response }

      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "#update" do
    let(:key) { model.model_name.param_key }

    subject do
      patch step_path, params: { key => details_params }
      response
    end

    context "with valid data" do
      let(:details_params) { attributes_for(:events_personal_details) }

      it { is_expected.to redirect_to authenticate_path }
    end

    context "with invalid data" do
      let(:details_params) { { "first_name" => "test" } }

      it { is_expected.to have_http_status :success }
    end

    context "with no data" do
      let(:details_params) { {} }

      it { is_expected.to have_http_status :success }
    end

    context "with last step" do
      context "when all valid" do
        before do
          allow_any_instance_of(Events::Steps::PersonalDetails).to \
            receive(:valid?).and_return true

          allow_any_instance_of(Wizard::Steps::Authenticate).to \
            receive(:valid?).and_return true

          allow_any_instance_of(Events::Steps::ContactDetails).to \
            receive(:valid?).and_return true

          allow_any_instance_of(Events::Steps::FurtherDetails).to \
            receive(:valid?).and_return true

          allow_any_instance_of(Events::Wizard).to \
            receive(:add_attendee_to_event).and_return true
        end

        let(:model) { Events::Steps::PersonalisedUpdates }
        let(:details_params) { attributes_for(:events_personalised_updates) }

        it { is_expected.to redirect_to completed_event_steps_path(readable_event_id) }
      end

      context "when invalid steps" do
        let(:model) { Events::Steps::PersonalisedUpdates }
        let(:details_params) { attributes_for(:events_personalised_updates) }

        it do
          is_expected.to redirect_to \
            event_step_path(readable_event_id, "personal_details")
        end
      end
    end
  end

  describe "#completed" do
    subject do
      get completed_event_steps_path(readable_event_id)
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
