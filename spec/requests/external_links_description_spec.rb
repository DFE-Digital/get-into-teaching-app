require "rails_helper"

describe "External link icon images", type: :request do
  before do
    allow(Sentry).to receive(:capture_message)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("APP_ASSETS_URL").and_return("https://external-asset.domain")
    get "/content-page"
  end

  subject { link.children.at("img")&.to_html }

  let(:markdown_links) do
    doc = Nokogiri::HTML.parse(response.body)
    doc.css(".markdown a")
  end

  it { expect(markdown_links.count).to eq(5) }

  context "when linking to an external website" do
    let(:link) { markdown_links[0] }

    it { expect(link[:href]).to eql("https://external.website/link") }

    it "has visually hidden text informing the user the link will open in a new window" do
      expect(link.at_css("span")).to be_present

      link.at_css("span").tap do |span|
        expect(span.classes).to include("visually-hidden")
        expect(span.text).to eql("(opens in new window)")
      end
    end
  end

  context "when linking to an internal path" do
    let(:link) { markdown_links[1] }

    it { expect(link[:href]).to eq("/internal") }
    it { is_expected.to be_nil }
  end

  context "when linking to an internal asset hosted on an external domain" do
    let(:link) { markdown_links[2] }

    it { expect(link[:href]).to eq("https://external-asset.domain/image.png") }
    it { is_expected.to be_nil }
  end

  context "when the link href was sanitized out" do
    let(:link) { markdown_links[3] }

    it { expect(link[:href]).to be_nil }
    it { expect(Sentry).to have_received(:capture_message).with("#{request.url} contains invalid anchor link") }
    it { is_expected.to be_nil }
  end

  context "when the link is a button" do
    let(:link) { markdown_links[4] }

    it { expect(link.classes).to include("button") }
    it { is_expected.to be_nil }
  end
end
