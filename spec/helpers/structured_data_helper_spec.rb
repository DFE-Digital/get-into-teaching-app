require "rails_helper"

describe StructuredDataHelper, type: "helper" do
  include ERB::Util
  include EventsHelper
  include Webpacker::Helper

  let(:image_path) { "media/images/getintoteachinglogo.svg" }

  describe ".structured_data" do
    subject(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    let(:malicious_text) { "</script><script>alert('PWNED!')</script>" }
    let(:html) { structured_data("Type", { text: malicious_text }) }

    before { enable_structured_data(:type) }

    it "returns nil when disabled by config" do
      disable_structured_data(:type)
      expect(script_tag).to be_nil
    end

    it "returns nil when not set in config" do
      disable_structured_data(:type, value: nil)
      expect(script_tag).to be_nil
    end

    it "wraps JSON in a script tag" do
      expect(script_tag).to be_present
      expect(script_tag[:type]).to eq("application/ld+json")
      expect { JSON.parse(script_tag.content) }.not_to raise_error
    end

    it "includes the context, type and data" do
      json = JSON.parse(script_tag.content)

      expect(json["@context"]).to eq("https://schema.org")
      expect(json["@type"]).to eq("Type")
      expect(json["text"]).to eq(malicious_text)
    end

    it "outputs escaped JSON" do
      escaped_malicious_text = json_escape(malicious_text)
      expect(script_tag.content).to include(escaped_malicious_text)
    end
  end

  describe ".how_to_structured_data" do
    subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

    let(:frontmatter) do
      {
        title: "Title",
        description: "Description",
        image: image_path,
        how_to: {
          "Decide who to teach": {
            id: "step-1",
            image: image_path,
            directions: [
              "Get school experience or attend events.",
            ],
          },
        },
      }
    end
    let(:page) { ::Pages::Page.new("/how-to-page", frontmatter) }
    let(:html) { how_to_structured_data(page) }
    let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    before { enable_structured_data(:how_to) }

    it "returns nil when disabled by config" do
      disable_structured_data(:how_to)
      expect(script_tag).to be_nil
    end

    it "includes how to information" do
      expect(data).to include({
        "@type": "HowTo",
        name: frontmatter[:title],
        description: frontmatter[:description],
        image: {
          "@type": "ImageObject",
          url: asset_pack_url(frontmatter[:image]),
        },
        step: [
          {
            "@type": "HowToStep",
            url: "http://test.host/how-to-page#step-1",
            name: "Decide who to teach",
            itemListElement: [
              {
                "@type": "HowToDirection",
                text: "Get school experience or attend events.",
              },
            ],
            image: {
              "@type": "ImageObject",
              url: asset_pack_url(image_path),
            },
          },
        ],
      })
    end

    context "when the image is not specified" do
      before { frontmatter[:image] = nil }

      it { is_expected.not_to have_key(:image) }
    end
  end

  describe ".blog_structured_data" do
    subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

    let(:frontmatter) do
      {
        title: "A title",
        images: {
          an_image: {
            "path" => image_path,
          },
        },
        date: "2021-01-25",
        keywords: %w[one two],
        author: "Ronald McDonald",
      }
    end
    let(:page) { ::Pages::Page.new("/blog/post", frontmatter) }
    let(:html) { blog_structured_data(page) }
    let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    before { enable_structured_data(:blog_posting) }

    it "returns nil when disabled by config" do
      disable_structured_data(:blog_posting)
      expect(script_tag).to be_nil
    end

    it "includes blog post information" do
      expect(data).to include({
        "@type": "BlogPosting",
        headline: frontmatter[:title],
        image: frontmatter[:images].values.map { |h| asset_pack_url(h["path"]) },
        datePublished: frontmatter[:date],
        keywords: frontmatter[:keywords],
        author: [
          {
            "@type": "Person",
            name: frontmatter[:author],
          },
        ],
      })
    end

    context "when author is not present" do
      before { frontmatter[:author] = nil }

      it "defaults to the Get Into Teaching organization" do
        expect(data).to include({
          author: [
            {
              "@type": "Organization",
              name: "Get Into Teaching",
            },
          ],
        })
      end
    end
  end

  describe ".search_structured_data" do
    subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

    let(:html) { search_structured_data }
    let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    before { enable_structured_data(:web_site) }

    it "returns nil when disabled by config" do
      disable_structured_data(:web_site)
      expect(script_tag).to be_nil
    end

    it "includes search information" do
      expect(data).to include({
        "@type": "WebSite",
        url: root_url,
        potentialAction: {
          "@type": "SearchAction",
          "target": {
            "@type": "EntryPoint",
            "urlTemplate": "http://test.host/search?search[search]={search_term_string}",
          },
          "query-input": "required name=search_term_string",
        },
      })
    end
  end

  describe ".logo_structured_data" do
    subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

    let(:html) { logo_structured_data }
    let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    before { enable_structured_data(:organization) }

    it "returns nil when disabled by config" do
      disable_structured_data(:organization)
      expect(script_tag).to be_nil
    end

    it "includes logo information" do
      expect(data).to include({
        "@type": "Organization",
        url: root_url,
        logo: asset_pack_url(image_path),
      })
    end
  end

  describe ".breadcrumbs_structured_data" do
    let(:html) { breadcrumbs_structured_data(breadcrumbs) }

    context "when there are breadcrumbs" do
      subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

      let(:breadcrumbs) do
        [
          Loaf::Breadcrumb.new("Page 1", "/page1", false),
          Loaf::Breadcrumb.new("Page 2", "/page2", true),
        ]
      end
      let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

      before { enable_structured_data(:breadcrumb_list) }

      it "returns nil when disabled by config" do
        disable_structured_data(:breadcrumb_list)
        expect(script_tag).to be_nil
      end

      it "includes breadcrumb information" do
        expect(data).to include({
          "@type": "BreadcrumbList",
          itemListElement: [
            {
              "@type": "ListItem",
              item: "http://test.host/page1",
              name: "Page 1",
              position: 1,
            },
            {
              "@type": "ListItem",
              item: "http://test.host/page2",
              name: "Page 2",
              position: 2,
            },
          ],
        })
      end
    end

    context "when there are no breadcrumbs" do
      subject { html }

      context "when empty array" do
        let(:breadcrumbs) { [] }

        it { is_expected.to be_nil }
      end

      context "when nil" do
        let(:breadcrumbs) { nil }

        it { is_expected.to be_nil }
      end
    end
  end

  describe ".event_structured_data" do
    subject(:data) { JSON.parse(script_tag.content, symbolize_names: true) }

    let(:event) { build(:event_api, building: nil) }
    let(:html) { event_structured_data(event) }
    let(:script_tag) { Nokogiri::HTML.parse(html).at_css("script") }

    before { enable_structured_data(:event) }

    it "returns nil when disabled by config" do
      disable_structured_data(:event)
      expect(script_tag).to be_nil
    end

    it "returns nil when not a TTT/QT event" do
      event = build(:event_api, :school_or_university_event)
      expect(event_structured_data(event)).to be_nil

      event = build(:event_api, :online_event)
      expect(event_structured_data(event)).to be_nil

      event = build(:event_api, :train_to_teach_event)
      expect(event_structured_data(event)).not_to be_nil

      event = build(:event_api, :question_time_event)
      expect(event_structured_data(event)).not_to be_nil
    end

    it "includes event information" do
      expect(data).to include({
        "@type": "Event",
        name: event.name,
        startDate: event.start_at,
        endDate: event.end_at,
        description: strip_tags(event.summary).strip,
        eventStatus: described_class::EVENT_SCHEDULED,
        eventAttendanceMode: described_class::OFFLINE_EVENT,
        offers: {
          "@type": "Offer",
          price: 0,
          priceCurrency: "GBP",
          availability: described_class::IN_STOCK,
        },
      })

      expect(data).not_to have_key(:organizer)
      expect(data).not_to have_key(:location)
    end

    context "when event summary is nil" do
      let(:event) { build(:event_api, summary: nil) }

      it { is_expected.to include({ description: nil }) }
    end

    context "when the event is online" do
      let(:event) { build(:event_api, :online) }

      it { is_expected.to include({ eventAttendanceMode: described_class::ONLINE_EVENT }) }

      it "has the online images" do
        is_expected.to include({ image: [
          "/packs-test/v1/media/images/structured_data/ttt_online_1x1-bf484c635cd3e795df567d2949dcf934.jpeg",
          "/packs-test/v1/media/images/structured_data/ttt_online_4x3-b85e3f4f32bc44694c87fa0fac81bbe1.jpeg",
          "/packs-test/v1/media/images/structured_data/ttt_online_16x9-a44602bd76aaec3798f3798d711310bd.jpeg",
        ] })
      end
    end

    context "when the event is in-person" do
      it "has the in-person images" do
        is_expected.to include({ image: [
          "/packs-test/v1/media/images/structured_data/ttt_in_person_1x1-7536d67c191fbc627baefc64808659a9.jpeg",
          "/packs-test/v1/media/images/structured_data/ttt_in_person_4x3-5c08900b1f812a977d05b21a4428eb7f.jpeg",
          "/packs-test/v1/media/images/structured_data/ttt_in_person_16x9-76e0739a9059dad3e151f07cfe169a75.jpeg",
        ] })
      end
    end

    context "when the event is closed" do
      let(:event) { build(:event_api, :closed) }

      it { expect(data[:offers]).to include({ availability: described_class::SOLD_OUT }) }
    end

    context "when there is provider information" do
      let(:event) { build(:event_api, :with_provider_info) }

      it "includes organizer" do
        expect(data[:organizer]).to include({
          "@type": "Organization",
          name: event.provider_organiser,
          email: event.provider_contact_email,
          url: event.provider_website_url,
        })
      end
    end

    context "when there is a building" do
      let(:event) { build(:event_api) }
      let(:building) { event.building }
      let(:street_address) do
        [
          building.address_line1,
          building.address_line2,
        ].compact.join(", ")
      end

      it "includes a location" do
        expect(data[:location]).to include({
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
        })
      end
    end
  end

  def enable_structured_data(type)
    allow(Rails.application.config.x.structured_data).to \
      receive(type).and_return(true)
  end

  def disable_structured_data(type, value: false)
    allow(Rails.application.config.x.structured_data).to \
      receive(type) { value }
  end
end
