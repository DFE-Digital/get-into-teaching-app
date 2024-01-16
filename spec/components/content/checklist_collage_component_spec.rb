require "rails_helper"

describe Content::ChecklistCollageComponent, type: :component do
  subject(:render) do
    render_inline(component) { content }
    page
  end

  let(:checklist) do
    [
      "A range of career paths",
      "Subject specialist, leadership and pastoral opportunities",
      "Flexible and secure",
    ]
  end
  let(:image_paths) do
    [
      "static/images/content/is-teaching-right-for-me/Physics_MissHayre_4.jpg",
      "static/images/content/is-teaching-right-for-me/collage1.jpg",
      "static/images/content/is-teaching-right-for-me/collage2.jpg",
    ]
  end
  let(:cta) do
    {
      text: "Explore career development options",
      link: "/",
    }
  end
  let(:content) { "<p>content</p>".html_safe }

  let(:component) { described_class.new(checklist: checklist, image_paths: image_paths, cta: cta) }

  it { is_expected.to have_css(".checklist-collage") }
  it { is_expected.to have_link(cta[:text], href: cta[:link]) }
  it { is_expected.to have_css("p", text: "content") }
  it { is_expected.to have_css(".images.images-3") }

  it "renders the checklist items" do
    checklist.each do |item|
      is_expected.to have_css("ul li", text: item)
    end
  end

  it "renders the images" do
    image_paths.each do |path|
      filename = path.split(".").first
      is_expected.to have_css("img[src*='#{filename}']")
    end
  end

  context "when cta is nil" do
    let(:cta) { nil }

    it { is_expected.not_to have_link }
  end
end
