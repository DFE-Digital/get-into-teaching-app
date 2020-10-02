require "rails_helper"

describe Prometheus::Metrics do
  let(:registry) { Prometheus::Client.registry }

  describe "request_total" do
    subject { registry.get(:requests_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of requests") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "request_duration_ms" do
    subject { registry.get(:request_duration_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request durations") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "request_view_runtime_ms" do
    subject { registry.get(:request_view_runtime_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of request view runtimes") }
    it { expect { subject.get(labels: %i[path method status]) }.to_not raise_error }
  end

  describe "render_view_ms" do
    subject { registry.get(:render_view_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of view rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.to_not raise_error }
  end

  describe "render_partial_ms" do
    subject { registry.get(:render_partial_ms) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A histogram of partial rendering times") }
    it { expect { subject.get(labels: %i[identifier]) }.to_not raise_error }
  end

  describe "cache_read_total" do
    subject { registry.get(:cache_read_total) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of cache reads") }
    it { expect { subject.get(labels: %i[key hit]) }.to_not raise_error }
  end
end
