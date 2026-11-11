require "rails_helper"

describe "Image Sizes", type: :request do
  let(:src) { "/assets/static/images/content/hero-images/teacher2-bb295dcc.jpg" }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("SIZE_IMAGES").and_return("1")
    allow(FastImage).to receive(:size).and_call_original
    get "/content-page"
  end

  subject { response.body }

  it "adds image sizes" do
    is_expected.to match(%r{width="1000" height="667" data-src="#{src}"})
  end
end
