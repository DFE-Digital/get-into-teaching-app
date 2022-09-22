require "rails_helper"

describe Content::QuoteSectionComponent, type: :component do
  subject do
    render_inline(component) do |section|
      section.with_quote(text: "Quote text")
      content
    end
    page
  end

  let(:component) do
    described_class.new(
      title: title,
      image: image,
      reverse: reverse,
    )
  end
  let(:title) { "Title" }
  let(:image) { "media/images/content/homepage/science-teacher.jpg" }
  let(:reverse) { false }
  let(:content) { "Content" }

  it { is_expected.to have_css(".quote-section h3", text: title) }
  it { is_expected.to have_css(".quote-section img[src='#{ActionController::Base.helpers.asset_pack_path(image)}']") }
  it { is_expected.to have_content(content) }
  it { is_expected.to have_css(".quote") }
  it { is_expected.not_to have_css(".quote-section--reverse") }

  context "when reverse" do
    let(:reverse) { true }

    it { is_expected.to have_css(".quote-section--reverse") }
  end

  describe "argument checks" do
    it do
      expect { described_class.new(title: nil, image: image) }.to \
        raise_error(ArgumentError, "title must be present")
    end

    it do
      expect { described_class.new(title: title, image: nil) }.to \
        raise_error(ArgumentError, "image must be present")
    end
  end
end
