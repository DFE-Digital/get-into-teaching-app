class ClientMetricsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    metric_json = JSON.parse(request.body.read)

    ActiveSupport::Notifications.instrument("app.client_metric", metric_json)

    head :ok
  end
end
