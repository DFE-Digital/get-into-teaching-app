require "rails_helper"
require "page_modification_tracker"

RSpec.describe PageModificationTracker do
  let(:host) { "test.host" }
  let(:selector) { "body" }
  let(:headers) { { "Host" => host } }
  let(:tracker) { described_class.new(host: host, selector: selector) }
  let(:path) { "/test-page" }
  let(:content) { "<html><head></head><body><h1>Test Content</h1></body></html>" }
  let(:content_hash) { Digest::SHA1.hexdigest("<body><h1>Test Content</h1></body>") }
  let(:mock_response) do
    instance_double(ActionDispatch::Response,
                    body: content,
                    headers: {})
  end

  before do
    allow_any_instance_of(ActionDispatch::Integration::Session)
      .to receive(:get)
      .with(path, headers: headers)
      .and_return(mock_response)

    allow_any_instance_of(ActionDispatch::Integration::Session)
      .to receive(:response)
      .and_return(mock_response)

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events)
      .and_return([])

    allow(::Pages::Frontmatter)
      .to receive(:list)
      .and_return({ path => { draft: false } })
  end

  describe "#track_page_modifications" do
    subject { tracker.track_page_modifications }

    context "when content has not changed" do
      before do
        PageModification.create!(path: path, content_hash: content_hash)
      end

      it "does not update the page modification" do
        expect { subject }.not_to(
          change { PageModification.find_by(path: path).updated_at }
        )
      end
    end

    context "when content has changed" do
      let!(:page_mod) { PageModification.create!(path: path, content_hash: "old-hash") }

      it "updates the page modification" do
        expect { subject }.to(
          change { page_mod.reload.content_hash }.to(content_hash),
        )
      end
    end

    context "when page is new" do
      it "creates a new page modification" do
        expect { subject }.to(
          change(PageModification, :count).by(1),
        )

        page_mod = PageModification.last
        expect(page_mod.path).to eq(path)
        expect(page_mod.content_hash).to eq(content_hash)
      end
    end

    context "when authenticity token changes" do
      let(:content) { '<html><head></head><body><h1>Test Content</h1><form><input type="hidden" name="authenticity_token" value="new-token"></form></body></html>' }
      let(:body_with_empty_token) { '<body><h1>Test Content</h1><form><input type="hidden" name="authenticity_token" value=""></form></body>' }
      let(:content_hash) { Digest::SHA1.hexdigest(Nokogiri::HTML(body_with_empty_token).css("body").to_s) } # Parse this as nokogiri behaves differently with forms

      before do
        PageModification.create!(path: path, content_hash: content_hash)
      end

      it "does not update the page modification when only the authenticity token changes" do
        expect { subject }.not_to(
          change { PageModification.find_by(path: path).updated_at }
        )
      end
    end

    context "with redirects" do
      let(:redirected_path) { "/final-path" }
      let(:redirected_content) { "<html><head></head><body><h1>Redirected Content</h1></body></html>" }
      let(:redirected_content_hash) { Digest::SHA1.hexdigest("<body><h1>Redirected Content</h1></body>") }
      let(:redirect_response) do
        instance_double(ActionDispatch::Response,
                        body: nil,
                        headers: { "Location" => redirected_path })
      end
      let(:final_response) do
        instance_double(ActionDispatch::Response,
                        body: redirected_content,
                        headers: {})
      end

      before do
        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:get)
          .with(path, headers: headers)
          .and_return(redirect_response)

        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:response)
          .and_return(redirect_response)

        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:get)
          .with(redirected_path, headers: headers)
          .and_return(final_response)

        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:response)
          .and_return(final_response)
      end

      it "follows the redirect and stores the original path" do
        subject
        page_mod = PageModification.last
        expect(page_mod.path).to eq(path)
        expect(page_mod.content_hash).to eq(redirected_content_hash)
      end
    end

    context "with nil or empty response" do
      let(:nil_response) do
        instance_double(ActionDispatch::Response,
                        body: nil,
                        headers: {})
      end

      before do
        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:get)
          .with(path, headers: headers)
          .and_return(nil_response)

        allow_any_instance_of(ActionDispatch::Integration::Session)
          .to receive(:response)
          .and_return(nil_response)
      end

      it "does not raise an error" do
        expect { subject }.not_to raise_error
      end

      it "does not create a page modification" do
        expect { subject }.not_to(
          change(PageModification, :count),
        )
      end
    end
  end
end
