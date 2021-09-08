require "rails_helper"

describe StaticPages do
  let(:testing_class) do
    Class.new do
      include StaticPages
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

  subject { tester.tap(&:render) }

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

  describe "#filtered_page_template" do
    let(:params) { { page: template } }

    before { allow(tester).to receive(:params).and_return params }

    subject { tester.send :filtered_page_template }

    context "with valid page template" do
      let(:template) { "hello" }

      it { is_expected.to eql "hello" }
    end

    context "with nested template" do
      let(:template) { "hello/world" }

      it { is_expected.to eql "hello/world" }
    end

    context "with invalid page template" do
      let(:template) { "invalid!" }

      it { expect { subject }.to raise_exception StaticPages::InvalidTemplateName }
    end

    context "with param linking to parent page" do
      let(:template) { "../../secrets.txt" }

      it { expect { subject }.to raise_exception StaticPages::InvalidTemplateName }
    end

    context "with file extension" do
      let(:template) { "stories/how-i-got-into-teaching.html" }

      it { is_expected.to eql "stories/how-i-got-into-teaching.html" }
    end

    context "with numbers in name" do
      let(:template) { "stories/my-top-10" }

      it { is_expected.to eql "stories/my-top-10" }
    end

    context "with custom page value" do
      let(:params) { { story: "hello" } }

      subject { tester.send :filtered_page_template, :story }

      it { is_expected.to eql "hello" }
    end
  end
end
