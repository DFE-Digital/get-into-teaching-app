class CspReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  CSP_KEYS = %w[
    blocked-uri
    disposition
    document-uri
    effective-directive
    original-policy
    referrer
    script-sample
    status-code
    violated-directive
  ].freeze
  MAX_ENTRY_LENGTH = 2_000

  def create
    json = JSON.parse(request.body.read)
    report = (json["csp-report"] || {})
      .slice(*CSP_KEYS)
      .transform_values { |v| v.truncate(MAX_ENTRY_LENGTH) }

    Rails.logger.error({ "csp-report" => report }) unless report.empty?

    head :ok
  end
end
