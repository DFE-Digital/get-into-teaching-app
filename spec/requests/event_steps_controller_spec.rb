require "rails_helper"

describe EventStepsController do
  include_context "stub types api"
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub event add attendee api"

  let(:readable_event_id) { "123" }
  let(:model) { Events::Steps::PersonalDetails }
  let(:step_path) { event_step_path readable_event_id, model.key }
  let(:authenticate_path) { event_step_path(readable_event_id, "authenticate") }
  let(:event) { build :event_api, readable_id: readable_event_id }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).and_return event
  end

  describe "#show" do
    before { get step_path }
    subject { response }
    it { is_expected.to have_http_status :success }

    context "when the event is closed" do
      let(:event) { build :event_api, :closed, readable_id: readable_event_id }

      it { is_expected.to redirect_to(event_path(id: event.readable_id)) }
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

    context "for last step" do
      context "when all valid" do
        before do
          allow_any_instance_of(Events::Steps::PersonalDetails).to \
            receive(:valid?).and_return true

          allow_any_instance_of(Events::Steps::Authenticate).to \
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

  describe "#resend_verification" do
    subject do
      get resend_verification_event_steps_path(readable_event_id, redirect_path: "redirect/path")
      response
    end
    it { is_expected.to redirect_to("redirect/path") }
  end
end
