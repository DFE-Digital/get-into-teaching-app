require "rails_helper"

describe Content::QuoteListComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:quote1) do
    {
      heading: "Heading 1",
      text: "Text 1",
      accreditation: "Accreditation 1",
    }
  end
  let(:quote2) do
    {
      heading: "Heading 2",
      text: "Text 2",
      accreditation: "Accreditation 2",
    }
  end
  let(:quotes) { [quote1, quote2] }
  let(:component) { described_class.new(quotes: quotes) }

  it { is_expected.to have_css("ol.quote-list") }

  it "renders quotes" do
    quotes.each.with_index do |quote, idx|
      within(render.all("li")[idx]) do
        it { is_expected.to have_css(".heading-wrapper h3", text: quote[:heading]) }
        it { is_expected.to have_css("blockquote", text: quote[:text]) }
        it { is_expected.to have_css("strong", text: quote[:accreditation]) }
      end
    end
  end

  describe "validation" do
    context "when the heading is not set" do
      before { quote2[:heading] = " " }

      it { expect { render }.to raise_error(ArgumentError, "heading must be present for quote 2") }
    end

    context "when the text is not set" do
      before { quote1[:text] = "" }

      it { expect { render }.to raise_error(ArgumentError, "text must be present for quote 1") }
    end

    context "when the accreditation is not set" do
      before { quote2[:accreditation] = [] }

      it { expect { render }.to raise_error(ArgumentError, "accreditation must be present for quote 2") }
    end
  end
end
