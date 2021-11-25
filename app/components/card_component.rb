class CardComponent < ViewComponent::Base
  MAX_HEADER_LENGTH = 70
  with_collection_parameter :card
  attr_accessor :snippet, :link, :link_text, :image, :video, :header, :border, :title

  def initialize(card:)
    super

    @card = card

    @snippet           = card["snippet"]
    @link              = card["link"]
    @link_text         = card["link_text"].presence || card["linktext"]
    @image             = card["image"]
    @image_description = card["image_description"]
    @video             = card["video"]
    @header            = card["header"]
    @title             = card["title"]
    @border            = card["border"] != false
  end

  def media_link
    @video ? video_link : image_link
  end

  def truncated_header
    header&.truncate(MAX_HEADER_LENGTH)
  end

  def modifier_classes
    [border_class].compact.join(" ")
  end

private

  def image_link
    link_to(thumbnail_image_tag, link, class: "card__thumb")
  end

  def thumbnail_image_tag
    helpers.image_pack_tag(image, data: { "object-fit" => "cover" }, size: "128x128", **thumbnail_image_alt_attribute)
  end

  def thumbnail_image_alt_attribute
    return {} if @image_description.blank?

    { alt: @image_description }
  end

  def video_link
    link_to(video, class: "card__thumb", data: { action: "click->video#play", "video-target": "link" }) do
      safe_join([tag.div(helpers.fas_icon("play"), class: "card__thumb--play-icon"), image_pack_tag(image, size: "128x128", **thumbnail_image_alt_attribute)])
    end
  end

  def border_class
    border ? nil : "card--no-border"
  end
end
