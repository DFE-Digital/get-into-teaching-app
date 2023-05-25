require "rails_helper"
require "disable_turbolinks"

describe DisableTurbolinks do
  describe "#html" do
    subject { instance.process.to_html }

    let(:anchor) { %(<a href="/tta-service">Get an adviser</a>) }
    let(:instance) { described_class.new(Nokogiri::HTML(anchor)) }

    it { is_expected.to include(%(data-turbolinks="false")) }

    context "when the link is not /tta-service" do
      let(:anchor) { %(<a href="/tta-service-other">Other</a>) }

      it { is_expected.not_to include(%(data-turbolinks)) }
    end
  end
end
