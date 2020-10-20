class CspReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    json = JSON.parse(request.body.read)
    report = json["csp-report"]

    Rails.logger.error(report) if report

    head :ok
  end
end
