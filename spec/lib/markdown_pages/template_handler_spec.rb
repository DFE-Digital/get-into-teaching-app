require "rails_helper"

describe MarkdownPages::TemplateHandler, type: :view do
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

        Lorem <strong>ipsum</strong>
      MARKDOWN
    end

    before do
      stub_template "test.md" => markdown
      render template: "test.md"
    end

    it { is_expected.to have_css("p", text: /Lorem/) }
    it { is_expected.to have_css("h1", text: "Heading") }
    it { is_expected.to have_css("p strong", text: "ipsum") }
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
end
