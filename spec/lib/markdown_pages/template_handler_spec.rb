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

    it do
      is_expected.to have_css \
        'a[href="https://www.gov.uk/autolink"]',
        text: "https://www.gov.uk/autolink"
    end
  end
end
