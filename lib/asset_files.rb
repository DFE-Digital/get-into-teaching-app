# Maps compiled asset URL paths back to files. In production the Propshaft
# output (and the derived responsive/next-gen images) lives in public/; in
# development and test assets are served dynamically from their sources.
module AssetFiles
  DIGEST = /-[0-9a-f]{8,}(?=\.[^.]+\z)/

  class << self
    def exist?(url_path)
      return true if File.exist?("#{Rails.public_path}#{url_path}")

      asset = dynamic_asset(url_path)
      asset.present? && asset.digested_path.to_s == url_path.delete_prefix(prefix)
    end

    # Returns the URL path of a sibling asset such as image--tablet.jpg, given
    # the URL path (minus extension and digest) of the original.
    def sibling_url_path(url_basename, suffix, ext)
      glob = Dir.glob("#{Rails.public_path}#{url_basename}#{suffix}*#{ext}").first
      return glob.sub(Rails.public_path.to_s, "") if glob

      dynamic_sibling(url_basename.delete_prefix(prefix), suffix, ext)
    end

  private

    def prefix
      "#{Rails.application.config.assets.prefix}/"
    end

    def dynamic?
      Rails.application&.config&.respond_to?(:assets) && Rails.application.config.assets.server
    end

    def dynamic_asset(url_path)
      return unless dynamic? && url_path.start_with?(prefix)

      logical = url_path.delete_prefix(prefix).sub(DIGEST, "")
      Rails.application.assets.load_path.find(logical)
    end

    def dynamic_sibling(logical_basename, suffix, ext)
      return unless dynamic?

      asset = Rails.application.assets.load_path.assets.find do |candidate|
        path = candidate.logical_path.to_s
        path.start_with?("#{logical_basename}#{suffix}") && path.end_with?(ext)
      end
      asset && Rails.application.assets.resolver.resolve(asset.logical_path.to_s)
    end
  end
end
