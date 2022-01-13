require "rails_helper"

describe Prometheus::Metrics do
  let(:registry) { Prometheus::Client.registry }

  describe "app_request_total" do
    subject { registry.get(:app_requests_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of requests") }
    it { expect { subject.get(labels: %i[path method status]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_csp_violations_total" do
    subject { registry.get(:app_csp_violations_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of CSP violations") }
    it { expect { subject.get(labels: %i[blocked_uri document_uri violated_directive]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_request_duration_ms" do
    subject { registry.get(:app_request_duration_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request durations") }
    it { expect { subject.get(labels: %i[path method status]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_request_view_runtime_ms" do
    subject { registry.get(:app_request_view_runtime_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request view runtimes") }
    it { expect { subject.get(labels: %i[path method status]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_render_view_ms" do
    subject { registry.get(:app_render_view_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of view rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_render_partial_ms" do
    subject { registry.get(:app_render_partial_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of partial rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_cache_read_total" do
    subject { registry.get(:app_cache_read_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of cache reads") }
    it { expect { subject.get(labels: %i[key hit]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_page_speed_score_performance" do
    subject { registry.get(:app_page_speed_score_performance) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "Google page speed scores (performance)") }
    it { expect { subject.get(labels: %i[strategy path]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_page_speed_score_accessibility" do
    subject { registry.get(:app_page_speed_score_accessibility) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "Google page speed scores (accessibility)") }
    it { expect { subject.get(labels: %i[strategy path]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_page_speed_score_seo" do
    subject { registry.get(:app_page_speed_score_seo) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "Google page speed scores (seo)") }
    it { expect { subject.get(labels: %i[strategy path]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  describe "app_client_cookie_consent_total" do
    subject { registry.get(:app_client_cookie_consent_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of cookie consent") }
    it { expect { subject.get(labels: %i[non_functional marketing]) }.not_to raise_error }
    it { is_expected.to have_attributes(preset_labels: expected_preset_labels) }
  end

  def expected_preset_labels
    {
      app: "app-name",
      organisation: "org-name",
      space: "space-name",
      app_instance: "app-instance",
    }
  end
end
