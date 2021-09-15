module WizardSteps
  extend ActiveSupport::Concern

  include DFEWizard::Controller

  included do
    before_action :process_magic_link_token, only: %i[show]
    before_action :display_magic_link_token_error, only: %i[show]
  end

  def resend_verification
    request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(camelized_identity_data)
    GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
    redirect_to authenticate_path(verification_resent: true)
  rescue GetIntoTeachingApiClient::ApiError => e
    redirect_to(first_step_path) && return if e.code == 400

    raise
  end

private

  def process_skip_verification
    return unless request.query_parameters[:skip_verification]

    request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(camelized_identity_data)
    @wizard.process_unverified_request(request)
    wizard_store["authenticate"] = false
    redirect_to(step_after_authenticate_path)
  rescue GetIntoTeachingApiClient::ApiError => e
    redirect_to(first_step_path) && return if e.code == 404

    raise
  end

  def process_magic_link_token
    token = request.query_parameters[:magic_link_token]
    return if token.blank?

    @wizard.process_magic_link_token(token)
    redirect_to(step_after_authenticate_path)
  rescue GetIntoTeachingApiClient::ApiError => e
    handle_magic_link_token_error(e) && return if e.code == 401

    raise
  end

  def handle_magic_link_token_error(error)
    response = JSON.parse(error.response_body)
    redirect_to(first_step_path(magic_link_token_error: response["status"]))
  end

  def display_magic_link_token_error
    magic_link_token_error = params[:magic_link_token_error]
    return if magic_link_token_error.blank?

    key = "activemodel.errors.magic_link_token"
    message = t("#{key}.#{magic_link_token_error.underscore}", default: t("#{key}.invalid"))
    @current_step.flash_error(message)
  end

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
