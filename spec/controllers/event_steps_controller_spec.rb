require "rails_helper"

describe EventStepsController, type: :request do
  let(:event_id) { SecureRandom.uuid }
  let(:model) { Events::Steps::PersonalDetails }
  let(:step_path) { event_step_path event_id, model.key }
  let(:contact_details_path) { event_step_path(event_id, "contact_details") }

  describe "#show" do
    before { get step_path }
    subject { response }
    it { is_expected.to have_http_status :success }
  end

  describe "#update" do
    let(:key) { model.model_name.param_key }
    before { patch step_path, params: { key => details_params } }
    subject { response }

    context "with valid data" do
      let(:details_params) { attributes_for(:events_personal_details) }
      it { is_expected.to redirect_to contact_details_path }
    end

    context "with invalid data" do
      let(:details_params) { { "first_name" => "test" } }
      it { is_expected.to have_http_status :success }
    end

    context "for last step" do
      let(:model) { Events::Steps::FurtherDetails }
      let(:details_params) { attributes_for(:events_further_details) }
      it { is_expected.to redirect_to root_path }
    end
  end
end
