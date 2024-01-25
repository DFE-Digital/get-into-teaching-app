module ImageHelper
  def image_alt(path)
    Image.new.alt(path)
  end

  def image_alt_attribs(path)
    image_alt_attribs_for_text(image_alt(path))
  end

  def image_alt_attribs_for_text(alt_text)
    {
      alt: alt_text,
    }.merge(
      alt_text.blank? ? { role: "presentation" } : {},
    )
  end
end
