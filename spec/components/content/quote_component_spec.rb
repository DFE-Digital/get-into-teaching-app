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
      inline: inline,
      background: background,
      large: large,
      classes: classes,
    )
  end
  let(:text) { "text goes here" }
  let(:name) { "name" }
  let(:job_title) { "job-title" }
  let(:inline) { nil }
  let(:background) { "white" }
  let(:large) { false }
  let(:classes) { "quote--extra" }

  describe "quote classes" do
    it { is_expected.to have_css(".quote") }
    it { is_expected.to have_css(".quote--background-white") }
    it { is_expected.to have_css(".quote--extra") }
  end

  describe "quote text" do
    it { is_expected.to have_css("p", text: text.split[0...-1].join(" ")) }
    it { is_expected.to have_css("span", text: text.split.last) }
  end

  describe "footer" do
    it { is_expected.to have_css(".footer") }

    describe "author" do
      it { is_expected.to have_css("cite", text: name) }
      it { is_expected.to have_css("cite", text: job_title) }
    end
  end

  context "when name is not specified" do
    let(:name) { nil }

    it { is_expected.not_to have_css(".author cite.name") }
  end

  context "when name contains html" do
    let(:name) { "<a href='/'>Link<a><script>malicious</script>" }

    it { is_expected.to have_css("cite a", text: "Link") }
    it { is_expected.not_to have_css("script") }
  end

  context "when job_title is not specified" do
    let(:job_title) { nil }

    it { is_expected.not_to have_css(".author cite.job-title") }
  end

  context "when inline right" do
    let(:inline) { "right" }

    it { is_expected.to have_css(".quote--inline-right") }
  end

  context "when inline left" do
    let(:inline) { "left" }

    it { is_expected.to have_css(".quote--inline-left") }
  end

  context "when background grey" do
    let(:background) { "grey" }

    it { is_expected.to have_css(".quote--background-grey") }
  end

  context "when large" do
    let(:large) { true }

    it { is_expected.to have_css(".quote--large") }
  end

  context "when no footer elements are present" do
    let(:name) { nil }
    let(:job_title) { nil }

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
      expect { described_class.new(text: text, inline: "bottom") }.to \
        raise_error(ArgumentError, "inline must be right or left")
    end

    it do
      expect { described_class.new(text: text, background: "green") }.to \
        raise_error(ArgumentError, "background must be grey or white")
    end
  end
end
