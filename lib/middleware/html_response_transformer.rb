require "next_gen_images"
require "lazy_load_images"
require "responsive_images"
require "new_tab_links"
require "image_sizes"
require "error_title"
require "accessible_footnotes"

module Middleware
  class HtmlResponseTransformer
    TRANSFORMERS = [
      ImageSizes,
      NextGenImages,
      ResponsiveImages,
      LazyLoadImages,
      NewTabLinks,
      ErrorTitle,
      AccessibleFootnotes,
    ].freeze

    def initialize(app)
      @app = app
    end

    def transform_response?(headers, response)
      headers["Content-Type"]&.include?("text/html") &&
        response.is_a?(ActionDispatch::Response::RackBody)
    end

    def call(env)
      status, headers, response = @app.call(env)

      if transform_response?(headers, response)
        response = [transform(response.body)]
        headers["Content-Length"] = response.first.bytesize.to_s
      end

      [status, headers, response]
    end

    def transform(response_body)
      doc = Nokogiri::HTML(response_body)

      TRANSFORMERS.each { |klass| doc = klass.new(doc).process }

      html = doc.to_html(encoding: "UTF-8", indent: 2)

      # <source> has no content so should be self-closing; configuring Nokogiri
      # to remove the closing tags results in breakages elsewhere in the document,
      # so we have to remove them manually post image processing.
      html.gsub("</source>", "")
    end
  end
end
