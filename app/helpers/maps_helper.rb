require "addressable"

module MapsHelper
  GOOGLE_BASE_URL = "https://maps.googleapis.com".freeze
  EXTERNAL_MAP_URL = "https://www.google.com/maps/dir/?api=1&destination={destination}".freeze
  STATIC_MAP_URL = "#{GOOGLE_BASE_URL}/maps/api/staticmap{?params*}".freeze

  def include_maps_in_head
    map_api_key = Rails.application.config.x.google_maps_key
    content_for :head do
      javascript_include_tag \
        "https://maps.googleapis.com/maps/api/js?key=#{map_api_key}&loading=async&callback=mapsLoadedCallback",
        defer: true, async: true
    end
  end

  def static_map_url(destination, mapsize:, zoom: 17, scale: 2)
    return if Rails.application.config.x.google_maps_key.blank?

    params = {
      center: destination,
      key: Rails.application.config.x.google_maps_key,
      markers: destination,
      scale: scale,
      size: mapsize.join("x"),
      zoom: zoom,
    }

    tmpl = Addressable::Template.new(STATIC_MAP_URL)
    tmpl.expand(params: params).to_s
  end

  def ajax_map(destination, mapsize:, title: nil, description: nil,
               zoom: 17, include_js_in_head: true)
    return if Rails.application.config.x.google_maps_key.blank?

    map_data = {
      controller: "map",
      map_destination: destination,
      map_title: title,
      map_description: description,
    }

    static_url = static_map_url(
      destination,
      mapsize: mapsize,
      zoom: zoom,
    )

    include_maps_in_head if include_js_in_head

    aria_attributes = {
      'aria-label': "Map showing #{title}",
    }

    tag.div class: "embedded-map", data: map_data, **aria_attributes do
      tag.div class: "embedded-map__inner-container",
              data: { "map-target": "container" } do
        image_tag static_url, class: "embedded-map__nojs-img", alt: "Map showing #{title}", **aria_attributes
      end
    end
  end

  def external_map_url(destination:, name:, zoom: 17)
    tmpl = Addressable::Template.new(EXTERNAL_MAP_URL)
    tmpl.expand(destination: destination, zoom: zoom, name: name).to_s
  end
end
