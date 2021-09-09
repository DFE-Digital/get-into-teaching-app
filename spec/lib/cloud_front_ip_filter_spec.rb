require "rails_helper"
require "cloud_front_ip_filter"

RSpec.describe CloudFrontIpFilter do
  subject { described_class.new original }

  before do
    stub_request(:get, "https://ip-ranges.amazonaws.com/ip-ranges.json")
      .to_return(status: 401) # will fallback to copy in Gem
  end

  let(:original) { ->(ip) { /192\.168\.1\./.match?(ip) } }

  describe "#call" do
    context "with private ips" do
      it { expect(subject.call("192.168.1.10")).to be true }
      it { expect(subject.call("192.168.2.10")).to be false }
      it { expect(subject.call("192.168.1.1")).to be true }
      it { expect(subject.call("192.168.1.254")).to be true }
    end

    context "with other ips" do
      it { expect(subject.call("51.8.222.98")).to be false }
    end

    context "with cloudfront ips" do
      it { expect(subject.call("15.207.13.128")).to be true }
      it { expect(subject.call("15.207.13.254")).to be true }
    end

    context "with ips just outside cloudfronts ranges" do
      it { expect(subject.call("15.207.13.1")).to be false }
      it { expect(subject.call("15.207.13.127")).to be false }
    end
  end
end
