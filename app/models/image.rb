class Image
  class UnregisteredImageError < KeyError; end

  def self.image_data
    @@image_data ||= YAML
      .load_file(Rails.root.join("config/images.yml"))
      .each
      .with_object({}) do |(main_file, metadata), mapping|
        mapping[main_file] = metadata["alt"]

        metadata["variants"]&.each { |v| mapping[v] = metadata["alt"] }
      end
  end
  delegate :image_data, to: :class

  # returns args that can be splatted into image_pack_tag
  def build_args(path)
    [path, { alt: alt(path) }]
  end

  # just return the alt text for an image
  def alt(path)
    image_data.fetch(path)
  rescue KeyError
    fail(UnregisteredImageError, %(no image information found for '#{path}', see config/images.yml))
  end
end
