module WizardSteps
  extend ActiveSupport::Concern
  include DFEWizard::Controller

  def resend_verification
    request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(camelized_identity_data)
    GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
    redirect_to authenticate_path(verification_resent: true)
  rescue GetIntoTeachingApiClient::ApiError => e
    redirect_to(first_step_path) && return if e.code == 400

    raise
  end

private

  def load_wizard
    super
  rescue DFEWizard::UnknownStep
    raise_not_found
  end

  def authenticate_path(params = {})
    step_path :authenticate, params
  end

  def camelized_identity_data
    Wizard::Steps::Authenticate.new(nil, wizard_store)
      .candidate_identity_data
  end
end
