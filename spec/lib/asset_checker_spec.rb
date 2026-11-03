require "spec_helper"
require "asset_checker"
require "faraday"

describe AssetChecker do
  let(:root_url) { "https://example.com" }
  let(:js_asset) { "/assets/application-0a1b2c3d.js" }
  let(:css_asset) { "/assets/application-4e5f6a7b.css" }
  let(:html) do
    <<~HTML
      <html>
        <head>
          <script src="#{js_asset}"></script>
          <link rel="stylesheet" href="#{css_asset}" />
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

    context "when the page references no assets" do
      let(:html) { "<html><head></head></html>" }

      it { is_expected.to eq([root_url]) }
    end

    context "when assets are served from the asset host" do
      let(:js_asset) { "https://assets.example.org/assets/application-0a1b2c3d.js" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("APP_ASSETS_URL").and_return("https://assets.example.org")
        stub_request(:get, js_asset).to_return(status: 404)
        stub_request(:get, root_url + css_asset).to_return(status: 200)
      end

      it { is_expected.to contain_exactly(js_asset) }
    end

    context "when the page has duplicate, inline and non-stylesheet references" do
      let(:html) do
        <<~HTML
          <script src="#{js_asset}"></script>
          <script src="#{js_asset}"></script>
          <script>window.inline = true</script>
          <link rel="stylesheet" href="#{css_asset}" />
          <link rel="preload" href="/assets/not-checked.woff2" />
        HTML
      end

      before do
        stub_request(:get, root_url + js_asset).to_return(status: 404)
        stub_request(:get, root_url + css_asset).to_return(status: 200)
      end

      it { is_expected.to contain_exactly(root_url + js_asset) }
    end

    context "when an asset request times out" do
      before do
        stub_request(:get, root_url + js_asset).to_timeout
        stub_request(:get, root_url + css_asset).to_return(status: 200)
      end

      it { is_expected.to contain_exactly(root_url + js_asset) }
    end

    context "when the page references a non-http script" do
      let(:js_asset) { "javascript:void(0)" }

      before { stub_request(:get, root_url + css_asset).to_return(status: 200) }

      it { is_expected.to be_empty }
    end

    context "when a script comes from an untrusted host" do
      let(:js_asset) { "https://evil.example.net/x.js" }

      before { stub_request(:get, root_url + css_asset).to_return(status: 200) }

      it { is_expected.to be_empty }
    end
  end
end
