module StructuredDataHelper
  ONLINE_EVENT = "https://schema.org/OnlineEventAttendanceMode".freeze
  OFFLINE_EVENT = "https://schema.org/OfflineEventAttendanceMode".freeze
  IN_STOCK = "https://schema.org/InStock".freeze
  SOLD_OUT = "https://schema.org/SoldOut".freeze
  EVENT_SCHEDULED = "https://schema.org/EventScheduled".freeze

  def structured_data(type, data)
    return unless Rails.application.config.x.structured_data.send(type.underscore)

    output = {
      "@context": "https://schema.org",
      "@type": type,
    }.merge(data)

    tag.script(type: "application/ld+json") do
      raw json_escape(output.to_json)
    end
  end

  def government_organization_structured_data
    data = {
      "@context": "https://schema.org/",
      "@type": "GovernmentOrganization",
      mainEntityOfPage: {
        "@type": "WebPage",
        "@id": "https://www.getintoteaching.education.gov.uk/",
      },
      name: "Get Into Teaching",
      description: "Nobody knows teaching like we do. Whether you're just thinking about it or ready to apply, we offer free advice and support to decide if teaching in a primary or secondary school in England is right for you. Discover a career with lots of opportunities to grow.",
      potentialAction: {
        "@type": "SearchAction",
        description: "Search for content from Get Into Teaching",
        target: "https://www.getintoteaching.education.gov.uk/search?q={search_term_string}",
        "query-input": "required name=search_term_string",
      },
    }

    structured_data("GovernmentOrganization", data)
  end

  def blog_structured_data(page)
    frontmatter = page.frontmatter
    author_name = frontmatter[:author]

    data = {
      headline: frontmatter[:title],
      image: frontmatter[:images]&.values&.map { |h| asset_pack_url(h["path"]) },
      datePublished: frontmatter[:date],
      keywords: frontmatter[:keywords],
      author: [
        {
          "@type": author_name.present? ? "Person" : "Organization",
          name: author_name || "Get Into Teaching",
        },
      ],
    }.compact

    structured_data("BlogPosting", data)
  end

  def home_structured_data
    data = {
      name: "Get Into Teaching",
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
      logo: asset_pack_url("static/images/getintoteachinglogo.svg"),
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
    return unless event.type_id.in?([git_event_type_id])

    building_data = event_building_data(event)
    provider_data = event_provider_data(event)
    image_data = event_image_data(event)

    data = {
      name: event.name,
      startDate: event.start_at,
      endDate: event.end_at,
      description: strip_tags(event.summary)&.strip,
      eventAttendanceMode: event.is_online ? ONLINE_EVENT : OFFLINE_EVENT,
      eventStatus: EVENT_SCHEDULED,
      offers: {
        "@type": "Offer",
        price: 0,
        priceCurrency: "GBP",
        availability: Crm::EventStatus.new(event).open? ? IN_STOCK : SOLD_OUT,
      },
    }.merge(building_data, provider_data, image_data)

    structured_data("Event", data)
  end

  def event_image_data(event)
    images = if event.is_online
               [
                 asset_pack_url("static/images/structured_data/git_online_1x1.jpeg"),
                 asset_pack_url("static/images/structured_data/git_online_4x3.jpeg"),
                 asset_pack_url("static/images/structured_data/git_online_16x9.jpeg"),
               ]
             else
               [
                 asset_pack_url("static/images/structured_data/git_in_person_1x1.jpeg"),
                 asset_pack_url("static/images/structured_data/git_in_person_4x3.jpeg"),
                 asset_pack_url("static/images/structured_data/git_in_person_16x9.jpeg"),
               ]
             end

    { image: images }
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
    }
  end
end
