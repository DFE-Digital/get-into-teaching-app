module ImageHelper
  def image_args(path)
    Image.new.build_args(path)
  end

  def image_alt(path)
    Image.new.alt(path)
  end
end
