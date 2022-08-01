class Content::CampaignHeroComponentPreview < ViewComponent::Preview
  def with_default
    render(Content::CampaignHeroComponent.new(frontmatter))
  end

private

  def frontmatter
    {
      title: "Overcoming hurdles.",
      subtitle: "Could you teach it?",
      image: "media/images/content/hero-images/m_dfe_lowther_room_6r_6595.jpg",
    }
  end
end
