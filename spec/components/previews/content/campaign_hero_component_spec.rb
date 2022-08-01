require "rails_helper"

describe Content::CampaignHeroComponent, type: "component" do
  subject do
    render_inline(component)
    page
  end

  let(:component) { described_class.new(front_matter) }
  let(:front_matter) do
    {
      "title" => "Overcoming hurdles.",
      "subtitle" => "Could you teach it?",
      "image" => "media/images/content/hero-images/m_dfe_lowther_room_6r_6595.jpg",
    }
  end

  it { is_expected.to have_css(".campaign-hero") }
  it { is_expected.to have_css(".campaign-hero__background") }
  it { is_expected.to have_css(".campaign-hero__title", text: front_matter["title"]) }
  it { is_expected.to have_css(".campaign-hero__subtitle", text: front_matter["subtitle"]) }
  it { is_expected.to have_css("img[data-lazy-disable=true]") }
end
