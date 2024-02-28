require "spec_helper"
require "error_title"

describe ErrorTitle do
  describe "#html" do
    subject { instance.process.to_html }

    let(:document) do
      <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <title>#{document_title}</title>
          </head>
          <body>#{body}</body>
        </html>
      HTML
    end
    let(:document_title) { "Title of the document" }
    let(:body) do
      <<~HTML
        <div class="govuk-error-summary"></div>
      HTML
    end
    let(:instance) { described_class.new(Nokogiri::HTML(document)) }

    it { is_expected.to include("<title>Error: #{document_title}</title>") }

    context "when there are no errors on the page" do
      let(:body) do
        <<~HTML
          <div>No errors here!</div>
        HTML
      end

      it { is_expected.to include("<title>#{document_title}</title>") }
    end
  end
end
