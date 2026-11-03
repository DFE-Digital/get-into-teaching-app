require "rails_helper"

describe "Asset pipeline" do
  let(:resolver) { Rails.application.assets.resolver }

  %w[
    application.css
    application_no_js.css
    internal.css
    static/images/logo/teaching_blue_background.svg
    fonts/montserrat/montserrat-v31-latin-100.woff2
    fa-solid-900.woff2
    images/govuk-crest.svg
  ].each do |logical_path|
    it "resolves #{logical_path}" do
      expect(resolver.resolve(logical_path)).to be_present
    end
  end

  it "does not serve Sass sources" do
    expect(Rails.application.assets.load_path.find("application.scss")).to be_nil
  end

  it "serves compiled CSS" do
    get ActionController::Base.helpers.asset_path("application.css")
    expect(response).to have_http_status(:ok)
  end
end
