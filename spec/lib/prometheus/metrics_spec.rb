require "rails_helper"

describe Prometheus::Metrics do
  let(:registry) { Prometheus::Client.registry }

  describe "page_helpful" do
    subject { registry.get(:page_helpful) }

    it { is_expected.not_to be_nil }
    it { is_expected.to have_attributes(docstring: "A counter of 'is this page helpful' responses") }
    it { expect { subject.get(labels: %i[url answer]) }.to_not raise_error }
  end
end
