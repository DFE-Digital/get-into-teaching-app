require "rails_helper"

describe Categories::CardComponent, type: "component" do
  let(:description) { "Test category card description" }
  let(:item) do
    OpenStruct.new(
      title: "Test category card title",
      description: description,
      path: "/a/b/c/",
    )
  end

  subject do
    render_inline(described_class.new(card: item))
    page
  end

  specify "renders a link within a list" do
    expect(subject).to have_link(item.title, href: item.path)
    expect(subject).to have_css("li.category__nav-card > a")
  end

  specify "the link contains a h2 title by default" do
    expect(subject).to have_css("a > .category__nav-card--content > h2", text: item.title)
  end

  specify "the link contains the provided description" do
    expect(subject).to have_css("a > .category__nav-card--content > p", text: item.description)
  end

  context "when the description contains HTML" do
    let(:description) { "<b>Test</b><script>malicious</script>" }

    specify "renders safe HTML" do
      description = subject.find("a > .category__nav-card--content > p")
      expect(description.native.inner_html).to eq("<b>Test</b>malicious")
    end
  end

  context "when the heading_tag is overridden" do
    let(:custom_heading_tag) { "h4" }

    subject do
      render_inline(described_class.new(card: item, heading_tag: custom_heading_tag))
      page
    end

    specify "the custom heading tag is used" do
      expect(subject).to have_css("a > .category__nav-card--content > #{custom_heading_tag}", text: item.title)
    end
  end
end
