require "spec_helper"
require "new_tab_links"

describe NewTabLinks do
  describe "#html" do
    subject { instance.process.to_html }

    let(:instance) { described_class.new(Nokogiri::HTML(link)) }

    context "when the link is external and has class of 'new-tab'" do
      let(:link) { %(<a class="new-tab" href="https://link.link">link</a>) }

      it "adds new tab attributes and text" do
        is_expected.to include(
          %{<a class="new-tab" href="https://link.link" target="_blank" rel="noopener">link <span>(opens in new tab)</span></a>},
        )
      end
    end

    context "when the link does not have class of 'new-tab'" do
      let(:link) { %(<a href="https://link.link">link</a>) }

      it "does not add new tab attributes and text" do
        is_expected.to include(
          %(<a href="https://link.link">link</a>),
        )
      end
    end

    context "when the link has class of 'new-tab' and 'button'" do
      let(:link) { %(<a class="new-tab button" href="https://link.link">link</a>) }

      it "does not add new tab attributes and text" do
        is_expected.to include(
          %(<a class="new-tab button" href="https://link.link" target="_blank" rel="noopener">link</a>),
        )
      end
    end
  end
end
