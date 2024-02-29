require "rails_helper"

describe Content::PurpleBoxComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:heading) { "How to become a teacher" }
  let(:text) { "Find out which qualifications you need, what funding you can get and how to train to teach." }
  let(:image) { %(<img src="static/steps-graphic-black.png">).html_safe }
  let(:cta) do
    {
      text: "Find your route into teaching",
      path: "/steps-to-become-a-teacher",
    }
  end
  let(:component) do
    described_class.new(
      heading: heading,
      text: text,
      cta: cta,
      image: image,
    )
  end

  it { is_expected.to have_css(".purple-box .purple-box__background") }
  it { is_expected.to have_css(".purple-box__text", text: text) }
  it { is_expected.to have_link(cta[:text], href: cta[:path]) }
  it { is_expected.to have_css("img[src='static/steps-graphic-black.png']") }
end
