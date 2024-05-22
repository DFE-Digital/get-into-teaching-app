require "rails_helper"

describe Content::PhotoQuoteListComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:quote1) do
    {
      image: "static/images/content/hero-images/0029.jpg",
      heading: "Heading 1",
      text: "Text 1",
      accreditation: "Accreditation 1",
    }
  end
  let(:quote2) do
    {
      image: "static/images/content/hero-images/0011.jpg",
      heading: "Heading 2",
      text: "Text 2",
      accreditation: "Accreditation 2",
    }
  end
  let(:numbered) { true }
  let(:colors) { %w[pink green] }
  let(:quotes) { [quote1, quote2] }
  let(:component) { described_class.new(quotes, colors: colors, numbered: numbered) }

  it { is_expected.to have_css("ol.photo-quote-list.photo-quote-list--numbered") }
  it { is_expected.to have_css("li.item.pink") }
  it { is_expected.to have_css("li.item.green") }

  it "renders quotes" do
    quotes.each.with_index do |quote, idx|
      within(render.all(".item")[idx]) do
        it { is_expected.to have_css(".wrapper") }
        it { is_expected.to have_css("img", src: quote[:image]) }
        it { is_expected.to have_css("h3", text: quote[:heading]) }
        it { is_expected.to have_css("blockquote", text: quote[:text]) }
        it { is_expected.to have_css("strong", text: quote[:accreditation]) }
      end
    end
  end

  context "when numbered is false" do
    let(:numbered) { false }

    it { is_expected.not_to have_css("ol.photo-quote-list.photo-quote-list--numbered") }
  end

  describe "validation" do
    context "when the image is not set" do
      before { quote1[:image] = nil }

      it { expect { render }.to raise_error(ArgumentError, "image must be present for quote 1") }
    end

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
