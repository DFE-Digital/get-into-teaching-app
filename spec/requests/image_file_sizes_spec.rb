require "rails_helper"

describe "Image File Sizes", type: :request do
  it "prevents large images from being added" do
    images = Dir.glob("app/webpacker/images/**/*")

    expect(images).to all(be_an_optimised_image)
  end
end
