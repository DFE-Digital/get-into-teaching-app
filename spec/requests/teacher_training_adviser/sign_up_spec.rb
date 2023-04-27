require "rails_helper"

RSpec.describe "Sign up" do
  let(:model) { TeacherTrainingAdviser::Steps::Identity }
  let(:step_path) { teacher_training_adviser_step_path model.key }

  describe "#show" do
    subject { response }

    before { get step_path }

    it { is_expected.to have_http_status :success }

    context "with an invalid step" do
      let(:step_path) { teacher_training_adviser_step_path(:invalid) }

      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "#update" do
    subject do
      patch step_path, params: { key => params }
      response
    end

    let(:key) { model.model_name.param_key }

    context "with valid data" do
      before do
        # Emulate an unsuccessful matchback response from the API.
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
          receive(:create_candidate_access_token)
          .and_raise(GetIntoTeachingApiClient::ApiError)
      end

      let(:params) { { first_name: "John", last_name: "Doe", email: "john@doe.com", accepted_policy_id: "latest" } }

      it { is_expected.to redirect_to teacher_training_adviser_step_path("returning_teacher") }
    end

    context "with invalid data" do
      let(:params) { { "email" => "invaild-email" } }

      it { is_expected.to have_http_status :unprocessable_entity }
    end

    context "when the last step" do
      let(:steps) { TeacherTrainingAdviser::Wizard.steps }
      let(:model) { steps.last }
      let(:params) { {} }

      context "when all valid and proceedable" do
        before do
          steps.each do |step|
            allow_any_instance_of(step).to receive(:valid?).and_return true
          end

          allow_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
            receive(:sign_up_teacher_training_adviser_candidate).once
        end

        it { is_expected.to redirect_to completed_teacher_training_adviser_steps_path }
      end

      context "when there is an invalid step" do
        let(:invalid_step) { steps.first }

        before do
          steps.each do |step|
            allow_any_instance_of(step).to receive(:valid?).and_return true
          end

          allow_any_instance_of(invalid_step).to receive(:valid?).and_return false
        end

        it { is_expected.to redirect_to teacher_training_adviser_step_path(invalid_step.key) }
      end

      context "when there is a step that is not proceedable" do
        let(:non_proceedable_step) { steps.first }

        before do
          steps.each do |step|
            allow_any_instance_of(step).to receive(:can_proceed?).and_return true
          end

          allow_any_instance_of(non_proceedable_step).to receive(:can_proceed?).and_return false
        end

        it { is_expected.to redirect_to teacher_training_adviser_step_path(non_proceedable_step.key) }
      end
    end

    context "with a step that has no attributes" do
      include_context "with wizard store"

      let(:model) { TeacherTrainingAdviser::Steps::ReviewAnswers }
      let(:params) { {} }

      it { expect(model.new(nil, wizardstore).attributes).to be_empty }
      it { is_expected.to have_http_status :redirect }
    end
  end

  describe "#completed" do
    subject do
      get completed_teacher_training_adviser_steps_path
      response
    end

    it { is_expected.to have_http_status :success }
  end

  describe "#resend_verification" do
    it "redirects to the authentication_path with verification_resent: true" do
      expect_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token)
      get resend_verification_teacher_training_adviser_steps_path
      expect(response).to redirect_to controller.send(:authenticate_path, verification_resent: true)
    end

    context "when the API returns 429 too many requests" do
      subject! do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
          receive(:create_candidate_access_token).and_raise(too_many_requests_error)
        get resend_verification_teacher_training_adviser_steps_path
        response.body
      end

      let(:too_many_requests_error) { GetIntoTeachingApiClient::ApiError.new(code: 429) }

      it { is_expected.to match(/Too many requests/) }
      it { is_expected.to match(/You have tried to access a page too often/) }
    end

    context "when the API returns 400 bad request" do
      subject! do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
          receive(:create_candidate_access_token).and_raise(bad_request_error)
        get resend_verification_teacher_training_adviser_steps_path
      end

      let(:bad_request_error) { GetIntoTeachingApiClient::ApiError.new(code: 400) }

      it { is_expected.to redirect_to(teacher_training_adviser_step_path(:identity)) }
    end
  end
end
