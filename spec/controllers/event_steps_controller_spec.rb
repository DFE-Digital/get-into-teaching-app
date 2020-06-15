require "rails_helper"

describe EventStepsController, type: :request do
  let(:event_id) { SecureRandom.uuid }
  let(:step_path) { event_step_path event_id, "personal_details" }

  describe "#show" do
    before { get step_path }
    subject { response }
    it { is_expected.to have_http_status :success }
  end

  describe "#update" do
    let(:key) { Events::Steps::PersonalDetails.model_name.param_key }
    before { patch step_path, params: { key => contact_params } }
    subject { response }

    context "with valid data" do
      let(:contact_params) { attributes_for(:events_personal_details) }
      it { is_expected.to redirect_to root_path }
    end

    context "with invalid data" do
      let(:contact_params) { { "first_name" => "test" } }
      it { is_expected.to have_http_status :success }
    end
  end
end
