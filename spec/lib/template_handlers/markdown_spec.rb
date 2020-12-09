require "rails_helper"

describe TemplateHandlers::Markdown, type: :view do
  subject { rendered }

  context "generic markdown page" do
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
      render template: "test.md"
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
      render template: "test.md"
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
      render template: "frontmatter.md"
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

    before { view.instance_variable_set("@front_matter", original_front_matter) }

    before do
      stub_template "test.md" => markdown
      render template: "test.md"
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

        Find out more about <a href="#vat" title="VAT">VAT</a>
      MARKDOWN
    end

    before do
      stub_template "frontmatter.md" => markdown
      render template: "frontmatter.md"
    end

    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to match "exVAT" } # check it honours word boundaries

    it do
      is_expected.to have_css \
        "a[title=\"VAT\"] abbr[title=\"Value added tax\"]", text: "VAT"
    end
  end

  context "global frontmatter" do
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
      render template: "frontmatter.md"
    end

    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

    it do
      is_expected.to \
        have_css "abbr[title=\"Continuous professional development\"]", text: "CPD"
    end

    it { is_expected.to have_css "abbr[title=\"Pay as you earn\"]", text: "PAYE" }
  end
end
