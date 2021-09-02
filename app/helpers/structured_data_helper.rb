module StructuredDataHelper
  ONLINE_EVENT = "https://schema.org/OfflineEventAttendanceMode".freeze
  OFFLINE_EVENT = "https://schema.org/OnlineEventAttendanceMode".freeze
  IN_STOCK = "https://schema.org/InStock".freeze
  SOLD_OUT = "https://schema.org/SoldOut".freeze
  EVENT_SCHEDULED = "https://schema.org/EventScheduled".freeze

  def structured_data(type, data)
    return if Rails.env.production?

    output = {
      "@context": "https://schema.org",
      "@type": type,
    }.merge(data)

    tag.script(type: "application/ld+json") do
      raw json_escape(output.to_json)
    end
  end

  def blog_structured_data(page)
    frontmatter = page.frontmatter

    data = {
      headline: frontmatter[:title],
      image: frontmatter[:images].values.map { |h| h["path"] },
      datePublished: frontmatter[:date],
      keywords: frontmatter[:keywords],
      author: [
        {
          "@type": "Organization",
          name: frontmatter[:author],
        },
      ],
    }

    structured_data("BlogPosting", data)
  end

  def search_structured_data
    data = {
      url: root_url,
      potentialAction: {
        "@type": "SearchAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": CGI.unescape(search_url(search: { search: "{search_term_string}" })),
        },
        "query-input": "required name=search_term_string",
      },
    }

    structured_data("WebSite", data)
  end

  def logo_structured_data
    data = {
      url: root_url,
      logo: asset_pack_path("media/images/getintoteachinglogo.svg"),
    }

    structured_data("Organization", data)
  end

  def breadcrumbs_structured_data(breadcrumbs)
    return if breadcrumbs.blank?

    items = breadcrumbs.each_with_index.map do |crumb, index|
      {
        "@type": "ListItem",
        position: index + 1,
        name: crumb.name,
        item: root_url.chomp("/") + crumb.path,
      }
    end

    structured_data("BreadcrumbList", { itemListElement: items })
  end

  def event_structured_data(event)
    building_data = event_building_data(event)
    provider_data = event_provider_data(event)

    data = {
      name: event.name,
      startDate: event.start_at,
      endDate: event.end_at,
      description: strip_tags(event.description).strip,
      eventAttendanceMode: event.is_online ? ONLINE_EVENT : OFFLINE_EVENT,
      eventStatus: EVENT_SCHEDULED,
      offers: {
        "@type": "Offer",
        price: 0,
        priceCurrency: "GBP",
        availability: event_status_open?(event) ? IN_STOCK : SOLD_OUT,
      },
    }.merge(building_data, provider_data)

    structured_data("Event", data)
  end

  def event_provider_data(event)
    return {} unless event_has_provider_info?(event)

    {
      organizer: {
        "@type": "Organization",
        name: event.provider_organiser,
        email: event.provider_contact_email,
        url: event.provider_website_url,
      },
    }
  end

  def event_building_data(event)
    building = event.building

    return {} if building.nil? || event.is_online

    street_address = [
      building.address_line1,
      building.address_line2,
    ].compact.join(", ")

    {
      location: {
        "@type": "Place",
        name: building.venue,
        address: {
          "@type": "PostalAddress",
          addressCountry: "GB",
          streetAddress: street_address,
          addressLocality: building.address_city,
          addressRegion: building.address_line3,
          postalCode: building.address_postcode,
        },
      },
    }.tap do |data|
      data[:image] = [building.image_url] if building.image_url.present?
    end
  end
end
