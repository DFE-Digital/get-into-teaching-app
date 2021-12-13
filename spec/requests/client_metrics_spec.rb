require "rails_helper"

describe "Client metrics", type: :request do
  subject { response }

  let(:params) { { "key" => "app_client_cookie_consent_total", "labels" => { "non_functional" => true, "marketing" => false } } }
  let(:events) { [] }

  before do
    record_client_metric_events
    post client_metrics_path, params: params.to_json
  end

  it { is_expected.to have_http_status(:success) }
  it { expect(self).to have_recorded_metric(params) }

  def has_recorded_metric?(metric = nil)
    events.any? { |event| event.payload == metric }
  end

private

  def record_client_metric_events
    ActiveSupport::Notifications.subscribe("app.client_metric") do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end
  end
end
