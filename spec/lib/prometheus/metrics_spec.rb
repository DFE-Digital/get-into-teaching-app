require "rails_helper"

describe Prometheus::Metrics do
  let(:registry) { Prometheus::Client.registry }

  describe "app_request_total" do
    subject { registry.get(:app_requests_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of requests") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "app_csp_violations_total" do
    subject { registry.get(:app_csp_violations_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of CSP violations") }
    it { expect { subject.get(labels: %i[blocked_uri document_uri violated_directive]) }.to_not raise_error }
  end

  describe "app_request_duration_ms" do
    subject { registry.get(:app_request_duration_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request durations") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "app_request_view_runtime_ms" do
    subject { registry.get(:app_request_view_runtime_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request view runtimes") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "app_render_view_ms" do
    subject { registry.get(:app_render_view_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of view rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.to_not raise_error }
  end

  describe "app_render_partial_ms" do
    subject { registry.get(:app_render_partial_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of partial rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.to_not raise_error }
  end

  describe "app_cache_read_total" do
    subject { registry.get(:app_cache_read_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of cache reads") }
    it { expect { subject.get(labels: %i[key hit]) }.to_not raise_error }
  end
end
