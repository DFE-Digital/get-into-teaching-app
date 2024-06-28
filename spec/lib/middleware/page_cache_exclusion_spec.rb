require "rails_helper"
require "middleware/page_cache_exclusion"

describe Middleware::PageCacheExclusion, type: :request do
  let(:path) { "/test" }
  let(:response) do
    [
      <<~HTML,
        <form action="/test" method="get">
          cachable form example
        </form>
      HTML
    ]
  end

  before do
    allow(Rack::PageCaching::Cache).to receive(:delete)

    app = ->(env) { [200, env, response] }
    middleware = described_class.new(app)
    middleware.call(Rack::MockRequest.env_for("http://example.com#{path}"))
  end

  subject { Rack::PageCaching::Cache }

  it { is_expected.not_to have_received(:delete) }

  context "when the response body is nil" do
    let(:response) { [nil] }

    it { is_expected.not_to have_received(:delete) }
  end

  context "when the response body is an instance of ActionDispatch::Response::RackBody" do
    let(:response) { ActionDispatch::Response::RackBody.new(ActionDispatch::Response.new) }

    it { is_expected.not_to have_received(:delete) }
  end

  shared_context "when the response body contains a matching form method" do
    let(:form) do
      <<~HTML
        <form action="/test" method="#{form_method}">
          post form example
        </form>
      HTML
    end
    let(:response) { [form] }

    context "when a POST form method" do
      let(:form_method) { "PoSt" }

      it { is_expected.to have_received(:delete).with("#{path}.html") }
    end

    context "when a PUT form method" do
      let(:form_method) { "PUT" }

      it { is_expected.to have_received(:delete).with("#{path}.html") }
    end

    context "when a PATCH form method" do
      let(:form_method) { "patch" }

      it { is_expected.to have_received(:delete).with("#{path}.html") }
    end

    context "when the root path" do
      let(:path) { root_path }

      it { is_expected.to have_received(:delete).with("/index.html") }
    end

    context "when the response body is an instance of ActionDispatch::Response::RackBody" do
      let(:form_method) { "PoSt" }
      let(:response) do
        ActionDispatch::Response::RackBody.new(
          ActionDispatch::Response.new.tap do |r|
            r.body = form
          end,
        )
      end

      it { is_expected.to have_received(:delete).with("#{path}.html") }
    end
  end
end
