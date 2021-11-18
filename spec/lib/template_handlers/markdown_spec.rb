require "rails_helper"

describe TemplateHandlers::Markdown, type: :view do
  subject { rendered }

  context "with generic markdown page" do
    let(:markdown) do
      <<~MARKDOWN
        # Heading

        Lorem ipsum

        With a [link](https://www.gov.uk)

        With a https://www.gov.uk/autolink
      MARKDOWN
    end

    before do
      stub_template "test.md" => markdown
      render template: "test"
    end

    it { is_expected.to have_css("p", text: "Lorem") }
    it { is_expected.to have_css("h1", text: "Heading") }
    it { is_expected.to have_css("p", count: 3) }
    it { is_expected.to have_css('a[href="https://www.gov.uk"]', text: "link") }

    it "will autolink urls" do
      is_expected.to have_css \
        'a[href="https://www.gov.uk/autolink"]',
        text: "https://www.gov.uk/autolink"
    end
  end

  context "with html" do
    let(:markdown) do
      <<~MARKDOWN
        # Heading

        Lorem <strong class="testclass">ipsum</strong>
      MARKDOWN
    end

    before do
      stub_template "test.md" => markdown
      render template: "test"
    end

    it { is_expected.to have_css("p", text: /Lorem/) }
    it { is_expected.to have_css("h1", text: "Heading") }
    it { is_expected.to have_css("p strong.testclass", text: "ipsum") }
  end

  context "with front matter" do
    let :markdown do
      <<~MARKDOWN
        ---
        title: My frontmatter page
        other: some value
        front: true
        ---
        # Page with frontmatter

        This is a page with frontmatter in
      MARKDOWN
    end

    let(:frontmatter) { view.instance_variable_get("@front_matter") }

    before do
      stub_template "frontmatter.md" => markdown
      render template: "frontmatter"
    end

    it { is_expected.to have_css "h1", text: "Page with frontmatter" }

    it "will strip out the frontmatter from the rendered page" do
      is_expected.not_to match(/My frontmatter page/)
      is_expected.not_to match(/---/)
    end

    it "will assign frontmatter to @frontmatter variable" do
      expect(frontmatter).to include "title" => "My frontmatter page"
      expect(frontmatter).to include "other" => "some value"
    end

    it "will parse booleans" do
      expect(frontmatter).to include "front" => true
    end
  end

  context "with empty front matter" do
    let(:original_front_matter) { { "title": "Outer page" } }
    let :markdown do
      <<~MARKDOWN
        # Page without frontmatter (a partial)
      MARKDOWN
    end

    before do
      view.instance_variable_set("@front_matter", original_front_matter)
      stub_template "test.md" => markdown
      render template: "test"
    end

    it "won't overwrite existing frontmatter with no data" do
      expect(view.instance_variable_get("@front_matter")).to eql(original_front_matter)
    end
  end

  context "with acronyms" do
    let :markdown do
      <<~MARKDOWN
        ---
        title: My page
        acronyms:
          VAT: Value added tax
        ---

        All prices include VAT unless marked as exVAT

        Find out more about <span id="vat" title="VAT">VAT</a>
      MARKDOWN
    end

    before do
      stub_template "frontmatter.md" => markdown
      render template: "frontmatter"
    end

    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to match "exVAT" } # check it honours word boundaries

    it do
      is_expected.to have_css \
        "span[title=\"VAT\"] abbr[title=\"Value added tax\"]", text: "VAT"
    end
  end

  describe "global frontmatter" do
    let :global_front_matter do
      {
        "title" => "Default page title",
        "acronyms" => {
          "CPD" => "Continuous professional development",
          "VAT" => "Wrong definition",
        },
      }
    end

    let :markdown do
      <<~MARKDOWN
        ---
        acronyms:
          PAYE: Pay as you earn
          VAT: Value added tax
        ---
        I've been studying VAT and PAYE as part of my CPD
      MARKDOWN
    end

    before do
      allow(described_class).to \
        receive(:global_front_matter).and_return global_front_matter

      stub_template "frontmatter.md" => markdown
      render template: "frontmatter"
    end

    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

    it do
      is_expected.to \
        have_css "abbr[title=\"Continuous professional development\"]", text: "CPD"
    end

    it { is_expected.to have_css "abbr[title=\"Pay as you earn\"]", text: "PAYE" }
  end

  describe "injecting rich content" do
    let(:front_matter_with_calls_to_action) do
      {
        "title": "Page with rich content (calls to action)",
        "calls_to_action" => {
          "big-warning" => {
            "name" => "simple",
            "arguments" => {
              "title" => "be careful",
              "link_text" => "something is about to happen",
              "link_target" => "#",
              "icon" => "icon-arrow",
            },
          },
          "small-warning" => "chat_online",
        },
      }
    end

    let :markdown do
      <<~MARKDOWN
        # Some page

        Lorem ipsum dolor sit amet, consectetur adipiscing

        $big-warning$

        Donec in leo enim. Mauris aliquet nulla dolor

        $small-warning$

        $one-that-does-not-exist$
      MARKDOWN
    end

    before do
      allow(described_class).to receive(:global_front_matter).and_return(front_matter_with_calls_to_action)
      stub_template "page_with_rich_content.md" => markdown
      render template: "page_with_rich_content"
    end

    specify "should render the component" do
      expect(rendered).to have_css(".call-to-action", count: front_matter_with_calls_to_action["calls_to_action"].size)
    end

    specify "unregistered calls to action should be omitted" do
      expect(rendered).not_to have_content(/one-that-does-not-exist/)
    end
  end

  describe "injecting images" do
    let(:front_matter_with_images) do
      {
        "title": "Page with images",
        "images" => {
          "black" => { "path" => "media/images/dfelogo-black.svg", "other_attr" => "ignore", "alt" => "Dark" },
          "white" => { "path" => "media/images/dfelogo-white.svg", "other_attr" => "ignore", "alt" => "Light" },
        },
      }
    end

    let :markdown do
      <<~MARKDOWN
        # Some page

        $black$

        Donec in leo enim. Mauris aliquet nulla dolor

        $white$
      MARKDOWN
    end

    before do
      allow(described_class).to receive(:global_front_matter).and_return(front_matter_with_images)
      stub_template "page_with_rich_content.md" => markdown
      render template: "page_with_rich_content"
    end

    specify "the rendered output contains the specified images" do
      expect(rendered).to have_css("img", count: 2)

      %w[black white].each do |colour|
        expect(rendered).to have_css("img")
        expect(rendered).to match(%r{src\=\"/packs-test/v1/media/images/dfelogo-#{colour}-.*.svg\"})
        expect(rendered).to have_css(%(img[alt="#{front_matter_with_images.dig('images', colour, 'alt')}"]))
      end
    end
  end
end
