require "rails_helper"

describe "Image Sizes", type: :request do
  let(:src) { "/packs/v1/media/images/content/hero-images/0013-3570599669a8da7d375320f4003d2d61.jpg" }

  before do
    allow(FastImage).to receive(:size).and_return([1175, 839])
    get "/content-page"
  end

  subject { response.body }

  it "adds image sizes" do
    is_expected.to match(%r{width="1175" height="839" data-src="#{src}"})
  end
end
