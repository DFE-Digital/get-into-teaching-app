require "rails_helper"

describe MailingList::StepsController do
  include_context "stub types api"
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub mailing list add member api"

  it_behaves_like "a controller with a #resend_verification action" do
    def perform_request
      get resend_verification_mailing_list_steps_path(redirect_path: "redirect/path")
    end
  end

  let(:model) { MailingList::Steps::Name }
  let(:step_path) { mailing_list_step_path model.key }

  describe "#index" do
    before { get mailing_list_steps_path(query: "param") }
    subject { response }
    it { is_expected.to redirect_to(mailing_list_step_path({ id: :name, query: "param" })) }
  end

  describe "#show" do
    before { get step_path }
    subject { response }
    it { is_expected.to have_http_status :success }

    context "with an invalid step" do
      let(:step_path) { mailing_list_step_path :invalid }

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
      let(:details_params) { attributes_for(:mailing_list_name) }
      it { is_expected.to redirect_to mailing_list_step_path("authenticate") }
    end

    context "with invalid data" do
      let(:details_params) { { "first_name" => "test" } }
      it { is_expected.to have_http_status :success }
    end

    context "for last step" do
      let(:steps) { MailingList::Wizard.steps }
      let(:model) { steps.last }
      let(:details_params) { attributes_for :"mailing_list_#{model.key}" }

      context "when all valid" do
        before do
          steps.each do |step|
            allow_any_instance_of(MailingList::Wizard).to \
              receive(:add_member_to_mailing_list).and_return true

            allow_any_instance_of(step).to receive(:valid?).and_return true
          end
        end

        it { is_expected.to redirect_to completed_mailing_list_steps_path }
      end

      context "when invalid steps" do
        before do
          allow_any_instance_of(model).to receive(:valid?).and_return true
        end
        let(:details_params) { attributes_for :"mailing_list_#{model.key}" }
        it { is_expected.to redirect_to mailing_list_step_path steps.first.key }
      end
    end
  end

  describe "#completed" do
    subject do
      get completed_mailing_list_steps_path
      response
    end
    it { is_expected.to have_http_status :success }
  end
end
