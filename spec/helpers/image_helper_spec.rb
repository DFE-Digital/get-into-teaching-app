require "rails_helper"

describe ImageHelper, type: "helper" do
  let(:path) { "a/b/c" }
  let(:image_double) { instance_double(Image, build_args: {}, alt: "xyz") }

  describe "#image_args" do
    before do
      allow(Image).to receive(:new).and_return(image_double)
      image_args(path)
    end

    specify "passes the path to Image#build_args" do
      expect(image_double).to have_received(:build_args).with(path).once
    end
  end

  describe "#alt" do
    before do
      allow(Image).to receive(:new).and_return(image_double)
      image_alt(path)
    end

    specify "passes the path to Image#alt" do
      expect(image_double).to have_received(:alt).with(path).once
    end
  end
end
