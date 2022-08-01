require "rails_helper"

describe Categories::CardComponent, type: "component" do
  let(:item) do
    OpenStruct.new(
      title: "Test category card title",
      description: "Test category card description",
      path: "/a/b/c/",
    )
  end

  subject do
    render_inline(described_class.new(card: item))
    page
  end

  specify "renders a link" do
    expect(subject).to have_link(item.title, href: item.path)
    expect(subject).to have_css("a.category__nav-card")
  end

  specify "the link contains a h2 title by default" do
    expect(subject).to have_css("a > .category__nav-card--content > h2", text: item.title)
  end

  specify "the link contains the provided description" do
    expect(subject).to have_css("a > .category__nav-card--content > p", text: item.description)
  end

  specify "the link has an icon" do
    expect(subject).to have_css("a > .category__nav-card--icon")
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
