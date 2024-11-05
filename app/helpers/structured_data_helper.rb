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

  def government_organization_structured_data
    data = {
      "@context": "https://schema.org",
      "@type": "GovernmentOrganization",
      "url": "https://getintoteaching.education.gov.uk/",
      "name": "Get Into Teaching",
      "description": "Get Into Teaching is the official UK government service that provides comprehensive information and support for individuals considering a teaching career at primary or secondary level. It offers guidance on the qualifications needed, the routes into becoming a primary or secondary school teacher, funding options, and access to one-to-one advice. Get Into Teaching aims to help people become teachers by outlining the steps involved in training and certification, while promoting teaching as a rewarding career.",
      "alternateName": "GIT",
      "logo": "https://getintoteaching.education.gov.uk/packs/v1/static/images/logo/teaching_blue_background-b1b9e8f9c3c482b7f3d7.svg",
      "parentOrganization": {
        "@type": "GovernmentOrganization",
        "sameAs": "https://www.gov.uk/government/organisations/department-for-education",
      },
      "sameAs": [
        "https://www.facebook.com/getintoteaching",
        "https://www.instagram.com/get_into_teaching/",
        "https://www.linkedin.com/company/get-into-teaching/",
        "https://x.com/getintoteaching",
        "https://www.youtube.com/user/getintoteaching",
      ],
      "email": "getintoteaching.helpdesk@service.education.gov.uk",
    }

    structured_data("GovernmentOrganization", data)
  end

  def logo_structured_data
    data = {
      url: root_url,
      logo: asset_pack_url("static/images/logo/teaching_blue_background.svg"),
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
