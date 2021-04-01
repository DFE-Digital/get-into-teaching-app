class Fingerprinter
  attr_reader :content_dir
  attr_reader :assets_dir
  attr_reader :assets_public_path

  def initialize(content_dir, assets_dir, assets_public_path = nil)
    @content_dir = content_dir.to_s
    @assets_dir = assets_dir.to_s
    @assets_public_path = assets_public_path
  end

  def run
    content.each do |path|
      contents = File.read(path)
      File.open(path, "w") do |f|
        f.write(replace_asset_paths(contents))
      end
    end
  end

private

  def asset_hash_map
    @asset_hash_map ||= assets.each_with_object({}) do |asset, acc|
      acc[asset_path(asset)] = asset_path(hash_asset(asset))
    end
  end

  def hash_asset(asset)
    hash_asset_path(asset).tap do |new_path|
      File.rename(asset, new_path)
    end
  end

  def hash_asset_path(path)
    digest = Digest::SHA1.file(path).hexdigest
    ext = File.extname(path)
    filename_with_digest = "#{File.basename(path, ext)}-#{digest}"
    "#{File.dirname(path)}/#{filename_with_digest}#{ext}"
  end

  def asset_path(path)
    asset_path = path.sub(assets_dir, "")

    return asset_path if assets_public_path.blank?

    "#{assets_public_path}#{asset_path}"
  end

  def assets
    Dir["#{assets_dir}/**/*.*"]
  end

  def content
    Dir["#{content_dir}/**/*.*"]
  end

  def replace_asset_paths(content)
    matcher = /(["'\(\[,\s])(#{Regexp.escape(assets_public_path || "")}.+?)(["'\)\],\s])/

    content.dup.gsub(matcher) do |match|
      opening_char = Regexp.last_match(1)
      asset_path = Regexp.last_match(2)
      closing_char = Regexp.last_match(3)

      hashed_asset_path = asset_hash_map[asset_path]

      if hashed_asset_path
        "#{opening_char}#{hashed_asset_path}#{closing_char}"
      else
        match
      end
    end
  end
end
