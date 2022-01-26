require "rails_helper"

describe Content::QuoteComponent, type: :component do
  subject do
    render_inline(component)
    page
  end

  let(:component) do
    described_class.new(
      text: text,
      name: name,
      job_title: job_title,
      cta: cta,
      image: image,
      hang: hang,
      inline: inline,
    )
  end
  let(:text) { "text goes here" }
  let(:name) { "name" }
  let(:job_title) { "job-title" }
  let(:cta) { { title: "click this", link: "/cta" } }
  let(:image) { "media/images/content/homepage/science-teacher.jpg" }
  let(:hang) { "left" }
  let(:inline) { nil }

  describe "quote classes" do
    it { is_expected.to have_css(".quote.quote--hang-#{hang}") }
    it { is_expected.not_to have_css(".quote--inline-left") }
    it { is_expected.not_to have_css(".quote--inline-right") }
  end

  describe "quote text" do
    it { is_expected.to have_css("p", text: text.split[0...-1].join(" ")) }
    it { is_expected.to have_css("span", text: text.split.last) }
  end

  describe "footer" do
    it { is_expected.to have_css(".footer.footer--with-image") }

    describe "author" do
      it { is_expected.to have_css("img") }
      it { is_expected.to have_css("cite", text: name) }
      it { is_expected.to have_css("cite", text: job_title) }
    end

    describe "call to action" do
      it { is_expected.to have_link(cta[:title], href: cta[:link]) }
      it { is_expected.to have_css("a span", text: cta[:title].split.last) }
    end
  end

  context "when name is not specified" do
    let(:name) { nil }

    it { is_expected.not_to have_css(".author cite.name") }
  end

  context "when job_title is not specified" do
    let(:job_title) { nil }

    it { is_expected.not_to have_css(".author cite.job-title") }
  end

  context "when cta is not specified" do
    let(:cta) { nil }

    it { is_expected.not_to have_link }
  end

  context "when image is not specified" do
    let(:image) { nil }

    it { is_expected.not_to have_css("img") }
  end

  context "when inline right" do
    let(:inline) { "right" }

    it { is_expected.to have_css(".quote--inline-right") }
  end

  context "when inline left" do
    let(:inline) { "left" }

    it { is_expected.to have_css(".quote--inline-left") }
  end

  context "when no footer elements are present" do
    let(:name) { nil }
    let(:job_title) { nil }
    let(:image) { nil }
    let(:cta) { nil }

    it { is_expected.not_to have_css(".footer") }
  end

  describe "argument checks" do
    it do
      expect { described_class.new(text: nil) }.to \
        raise_error(ArgumentError, "text must be present")
    end

    it do
      expect { described_class.new(text: "  ") }.to \
        raise_error(ArgumentError, "text must be present")
    end

    it do
      expect { described_class.new(text: text, hang: nil) }.to \
        raise_error(ArgumentError, "hang must be right or left")
    end

    it do
      expect { described_class.new(text: text, hang: "up") }.to \
        raise_error(ArgumentError, "hang must be right or left")
    end

    it do
      expect { described_class.new(text: text, inline: "bottom") }.to \
        raise_error(ArgumentError, "inline must be right or left")
    end

    it do
      expect { described_class.new(text: text, cta: { title: "", link: "" }) }.to \
        raise_error(ArgumentError, "cta must contain a title and link")
    end
  end
end
