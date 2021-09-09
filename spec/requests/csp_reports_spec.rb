require "rails_helper"

describe "CSP violation reporting", type: :request do
  let(:params) { { "csp-report" => { "blocked-uri" => "https://malicious.com/script.js" } } }
  let(:events) { [] }

  before do
    record_csp_violation_events
    allow(Rails.logger).to receive(:error)
    post csp_reports_path, params: params.to_json
  end

  subject { response }

  it { is_expected.to have_http_status(:success) }
  it { expect(Rails.logger).to have_received(:error).with(params).once }
  it { expect(self).to have_recorded_csp_violation(params["csp-report"]) }

  describe "when called without a csp-report" do
    let(:params) { { other: "payload" } }

    it { is_expected.to have_http_status(:success) }
    it { expect(Rails.logger).not_to have_received(:error) }
    it { expect(self).not_to have_recorded_csp_violation }
  end

  describe "when the csp-report contains keys not in our whitelist" do
    let(:params) { { "csp-report" => { "blocked-uri" => "https://malicious.com/script.js", "random" => "information" } } }
    let(:expected_report) { params["csp-report"].slice("blocked-uri") }

    it { expect(Rails.logger).not_to have_received(:error).with(params) }
    it { expect(Rails.logger).to have_received(:error).with({ "csp-report" => expected_report }).once }
    it { expect(self).to have_recorded_csp_violation(expected_report) }
  end

  def has_recorded_csp_violation?(report = nil)
    return events.any? if report.nil?

    events.any? { |event| event.payload == report }
  end

private

  def record_csp_violation_events
    ActiveSupport::Notifications.subscribe("app.csp_violation") do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end
  end
end
