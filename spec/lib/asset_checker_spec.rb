require "rails_helper"
require "asset_checker"

describe AssetChecker do
  let(:root_url) { "https://example.com" }
  let(:js_asset) { "/packs/js/application-digest.js" }
  let(:css_asset) { "/packs/css/application-digest.css" }
  let(:html) do
    <<~HTML
      <html>
        <head>
          <script src="#{js_asset}"></script>
          <link href="#{css_asset}" />
        </head>
      </html>
    HTML
  end
  let(:instance) { described_class.new(root_url) }

  describe "#run" do
    subject(:run) { instance.run }

    before do
      stub_request(:get, root_url).to_return(status: 200, body: html)
    end

    context "when the assets are available" do
      before do
        stub_request(:get, root_url + js_asset).to_return(status: 200)
        stub_request(:get, root_url + css_asset).to_return(status: 200)
      end

      it { is_expected.to be_empty }
    end

    context "when the assets are not found" do
      before do
        stub_request(:get, root_url + js_asset).to_return(status: 404)
        stub_request(:get, root_url + css_asset).to_return(status: 404)
      end

      it { is_expected.to contain_exactly(root_url + js_asset, root_url + css_asset) }
    end
  end
end
