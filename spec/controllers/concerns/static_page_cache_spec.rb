require "rails_helper"

describe StaticPageCache do
  subject { tester.tap(&:render) }

  let(:testing_class) do
    Class.new do
      include StaticPageCache
      attr_reader :cacheable_static_page

      def render
        cache_static_page { fetch_content }
      end

      def fetch_content
        true
      end

      def stale?(*_args)
        true
      end

      def expires_in(*_args)
        true
      end

      def params
        {}
      end
    end
  end

  let(:tester) { testing_class.new }

  let(:config) { Rails.application.config.x.static_pages }
  let(:etag) { "12345" }
  let(:last_modified) { 2.minutes.ago }
  let(:expires_in) { 2.minutes }

  before do
    allow(config).to receive(:etag).and_return(etag)
    allow(config).to receive(:last_modified).and_return(last_modified)
    allow(config).to receive(:expires_in).and_return(expires_in)

    allow(tester).to receive(:stale?).and_call_original
    allow(tester).to receive(:expires_in).and_call_original
    allow(tester).to receive(:fetch_content).and_call_original
  end

  context "with caching disabled" do
    it { is_expected.to have_received :fetch_content }
    it { is_expected.not_to have_received :stale? }
    it { is_expected.not_to have_received :expires_in }
    it { is_expected.to have_attributes cacheable_static_page: nil }
  end

  context "with caching enabled" do
    before do
      allow(Rails.application.config.action_controller).to \
        receive(:perform_caching).and_return true
    end

    it { is_expected.to have_received(:fetch_content) }
    it { is_expected.to have_attributes cacheable_static_page: true }

    it do
      is_expected.to have_received(:stale?).with \
        etag: etag, last_modified: last_modified, public: true
    end

    it do
      is_expected.to have_received(:expires_in).with expires_in, public: true
    end
  end
end
