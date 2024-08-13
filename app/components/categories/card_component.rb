class Categories::CardComponent < ViewComponent::Base
  attr_reader :title, :description, :path, :heading_tag, :image

  include ContentHelper

  def initialize(card:, heading_tag: "h2")
    @title       = substitute_values(card.title)
    @description = substitute_values(card.description)
    @path        = card.path
    @heading_tag = heading_tag
    @image       = card.image if card.respond_to?(:image)

    super
  end

  def image?
    image.present?
  end

  def image_tag
    helpers.image_pack_tag(image, **helpers.image_alt_attribs(image))
  end
end
