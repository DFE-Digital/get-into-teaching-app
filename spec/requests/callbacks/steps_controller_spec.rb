require "rails_helper"

describe Callbacks::StepsController do
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub book callback api"

  it_behaves_like "a controller with a #resend_verification action" do
    def perform_request
      get resend_verification_callbacks_steps_path(redirect_path: "redirect/path")
    end
  end

  let(:model) { Callbacks::Steps::PersonalDetails }
  let(:step_path) { callbacks_step_path model.key }

  describe "#index" do
    before { get callbacks_steps_path(query: "param") }
    subject { response }
    it { is_expected.to redirect_to(callbacks_step_path({ id: :personal_details, query: "param" })) }
  end

  describe "#show" do
    before { get step_path }
    subject { response }
    it { is_expected.to have_http_status :success }

    context "with an invalid step" do
      let(:step_path) { callbacks_step_path :invalid }

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
      let(:details_params) { attributes_for(:callbacks_personal_details) }
      it { is_expected.to redirect_to callbacks_step_path("authenticate") }
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
      let(:steps) { Callbacks::Wizard.steps }
      let(:model) { steps.last }
      let(:details_params) { attributes_for :"callbacks_#{model.key}" }

      context "when all valid" do
        before do
          allow_any_instance_of(Callbacks::Wizard).to \
            receive(:book_callback).and_return true

          allow_any_instance_of(Callbacks::Steps::Callback).to \
            receive(:phone_call_scheduled_at) { DateTime.new(2021, 1, 1, 10) }

          steps.each do |step|
            allow_any_instance_of(step).to receive(:valid?).and_return true
          end
        end

        it { is_expected.to redirect_to completed_callbacks_steps_path(date: "01 January 2021", time: "10:00 am") }
      end

      context "when invalid steps" do
        before do
          allow_any_instance_of(model).to receive(:valid?).and_return true
        end
        let(:details_params) { attributes_for :"callbacks_#{model.key}" }
        it { is_expected.to redirect_to callbacks_step_path steps.first.key }
      end
    end
  end

  describe "#completed" do
    subject do
      get completed_callbacks_steps_path
      response
    end
    it { is_expected.to have_http_status :success }
  end
end
