require "spec_helper"
require "new_tab_links"

describe NewTabLinks do
  describe "#html" do
    subject { instance.process.to_html }

    let(:link) { %(<a class="new-tab" href="https://link.link">link</a>) }
    let(:instance) { described_class.new(Nokogiri::HTML(link)) }

    context "when the link is external and has class of 'new-tab'" do
      it "adds new tab attributes and text" do
        is_expected.to include(
          %{<a class="new-tab" href="https://link.link" target="_blank" rel="noopener">link <span>(opens in new tab)</span></a>},
        )
      end
    end

    context "when the link is internal and has class of 'new-tab'" do
      let(:link) { %(<a class="new-tab" href="/path">internal link</a>) }

      it "adds tab attributes and text" do
        is_expected.to include(
          %{<a class="new-tab" href="/path" target="_blank" rel="noopener">internal link <span>(opens in new tab)</span></a>},
        )
      end
    end
  end
end
