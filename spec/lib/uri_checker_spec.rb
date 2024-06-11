require "spec_helper"
require "uri_checker"

describe URIChecker do
  describe "#local_https?" do
    subject { described_class.new(URI.parse(uri)).local_https? }

    context "with remote http URI" do
      let(:uri) { "http://production.com:123456/api" }

      it { is_expected.to be false }
    end

    context "with remote https URI" do
      let(:uri) { "https://production.com:123456/api" }

      it { is_expected.to be false }
    end

    context "with local http URI" do
      let(:uri) { "http://localhost:123456/api" }

      it { is_expected.to be false }
    end

    context "with local https URI" do
      let(:uri) { "https://localhost:123456/api" }

      it { is_expected.to be true }
    end
  end
end
