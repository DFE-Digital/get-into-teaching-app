require "rails_helper"

describe "Instrumentation", type: :request do
  let(:registry) { Prometheus::Client.registry }

  describe "process_action.action_controller" do
    after { get cookies_path(query: "param") }

    it "increments the :app_requests_total metric" do
      metric = registry.get(:app_requests_total)
      expect(metric).to receive(:increment).with(labels: { path: "/cookies", method: "GET", status: 200 }).once
    end

    it "observes the :app_request_duration_ms metric" do
      metric = registry.get(:app_request_duration_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: { path: "/cookies", method: "GET", status: 200 }).once
    end

    it "observes the :app_request_view_runtime_ms metric" do
      metric = registry.get(:app_request_view_runtime_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: { path: "/cookies", method: "GET", status: 200 }).once
    end
  end

  describe "render_template.action_view" do
    after { get cookie_preference_path }

    it "observes the :app_render_view_ms metric" do
      metric = registry.get(:app_render_view_ms)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: {
        identifier: "cookie_preferences/show.html.erb",
      }).once
    end
  end

  describe "render_partial.action_view" do
    after { get root_path }

    it "observes the :app_render_view_ms metric" do
      metric = registry.get(:app_render_partial_ms)
      allow(metric).to receive(:observe)
      expect(metric).to receive(:observe).with(instance_of(Float), labels: {
        identifier: "sections/_head.html.erb",
      }).once
    end
  end

  describe "cache_read.active_support" do
    after { Rails.cache.read("test") }

    it "observes the :app_cache_read_total metric" do
      metric = registry.get(:app_cache_read_total)
      expect(metric).to receive(:increment).with(labels: {
        key: instance_of(String),
        hit: false,
      }).once
    end
  end

  describe "app.csp_violation" do
    let(:params) do
      {
        "csp-report" =>
        {
          "blocked-uri" => "http://document-uri.com/script.js?param=test",
          "document-uri" => "http://document-uri.com/path?param=test",
          "violated-directive": "violated-directive extra-info",
        },
      }
    end

    after { post csp_reports_path, params: params.to_json }

    it "increments the :app_csp_violations_total metric" do
      metric = registry.get(:app_csp_violations_total)
      expect(metric).to receive(:increment).with(labels:
        {
          blocked_uri: "http://document-uri.com/script.js",
          document_uri: "/path",
          violated_directive: "violated-directive",
        }).once
    end
  end

  describe "app.client_metrics" do
    let(:params) do
      {
        key: "app_client_cookie_consent_total",
        labels: {
          non_functional: true,
          marketing: false,
        },
      }
    end

    it "increments the client metric" do
      metric = registry.get(:app_client_cookie_consent_total)
      expect(metric).to receive(:increment).with(labels:
        {
          non_functional: true,
          marketing: false,
        }).once
      post client_metrics_path, params: params.to_json
    end

    context "when attempting to increment a non-client app metric" do
      before { params[:key] = "app_metric" }

      it "raises an error" do
        expect { post client_metrics_path, params: params.to_json }.to \
          raise_error(ArgumentError, "attempted to increment non-client metric")
      end
    end
  end
end
