require "rails_helper"
require "external_links"

describe ExternalLinks do
  describe "#html" do
    subject { instance.html }

    let(:link) { %(<a href="https://external.link">external link</a>) }
    let(:instance) { described_class.new(link) }

    it "adds visually hidden text" do
      is_expected.to include(
        %{<a href="https://external.link">external link<span class="visually-hidden">(opens in new window)</span></a>},
      )
    end

    context "when the link is a button" do
      let(:link) { %(<a class="button" href="https://external.link">external link</a>) }

      it { is_expected.not_to include("visually-hidden") }
    end

    context "when the link already contains visually hidden text" do
      let(:link) { %(<a class="button" href="https://external.link">external link<span class="visually-hidden">existing</span></a>) }

      it { is_expected.to include(link) }
    end

    context "when the link is internal" do
      let(:link) { %(<a href="/path">internal link</a>) }

      it { is_expected.to include(link) }
    end

    context "when the link does not contain a href" do
      let(:link) { %(<a>invalid link</a>) }

      it { is_expected.to include(link) }
    end
  end
end
