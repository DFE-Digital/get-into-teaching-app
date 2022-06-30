require "next_gen_images"
require "lazy_load_images"
require "responsive_images"
require "external_links"

module Middleware
  class HtmlResponseTransformer
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
      response_body = NextGenImages.new(response_body).html
      response_body = ResponsiveImages.new(response_body).html
      response_body = LazyLoadImages.new(response_body).html
      response_body = ExternalLinks.new(response_body).html

      # <source> has no content so should be self-closing; configuring Nokogiri
      # to remove the closing tags results in breakages elsewhere in the document,
      # so we have to remove them manually post image processing.
      response_body.gsub("</source>", "")
    end
  end
end
