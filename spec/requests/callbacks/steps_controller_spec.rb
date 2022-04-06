require "rails_helper"

describe Callbacks::StepsController, type: :request do
  include_context "with stubbed candidate create access token api"
  include_context "with stubbed latest privacy policy api"
  include_context "with stubbed book callback api"

  it_behaves_like "a controller with a #resend_verification action" do
    def perform_request
      get resend_verification_callbacks_steps_path(redirect_path: "redirect/path")
    end
  end

  let(:model) { Callbacks::Steps::PersonalDetails }
  let(:step_path) { callbacks_step_path model.key }

  describe "#index" do
    subject { response }

    before { get callbacks_steps_path(query: "param") }

    it { is_expected.to redirect_to(callbacks_step_path({ id: :personal_details, query: "param" })) }
  end

  describe "#show" do
    subject { response }

    before { get step_path }

    it { is_expected.to have_http_status :success }
    it { is_expected.not_to be_indexed }

    context "with an invalid step" do
      let(:step_path) { callbacks_step_path :invalid }

      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "#update" do
    subject do
      patch step_path, params: { key => details_params }
      response
    end

    let(:key) { model.model_name.param_key }

    context "with valid data" do
      let(:details_params) { attributes_for(:callbacks_personal_details) }

      it { is_expected.to redirect_to callbacks_step_path("authenticate") }
    end

    context "with invalid data" do
      let(:details_params) { { "first_name" => "test" } }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.not_to be_indexed }
    end

    context "with no data" do
      let(:details_params) { {} }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.not_to be_indexed }
    end

    context "with last step" do
      let(:steps) { Callbacks::Wizard.steps }
      let(:model) { steps.last }
      let(:details_params) { attributes_for :"callbacks_#{model.key}" }

      before do
        allow_any_instance_of(Callbacks::Steps::MatchbackFailed).to receive(:skipped?).and_return true
      end

      context "when all valid" do
        before do
          allow_any_instance_of(Callbacks::Wizard).to \
            receive(:book_callback).and_return true

          allow_any_instance_of(Callbacks::Steps::Callback).to \
            receive(:phone_call_scheduled_at) { Time.zone.local(2021, 1, 1, 10) }

          steps.each do |step|
            allow_any_instance_of(step).to receive(:valid?).and_return true
          end
        end

        it { is_expected.to redirect_to completed_callbacks_steps_path(date: "01 January 2021", time: "10:00am") }
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
    it { is_expected.not_to be_indexed }
  end
end
