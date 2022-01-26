require "rails_helper"

describe ImageHelper, type: "helper" do
  let(:path) { "a/b/c" }
  let(:alt) { "some alt text" }
  let(:args) { { some: "args" } }
  let(:image_double) { instance_double(Image, build_args: [path, args], alt: alt) }

  before { allow(Image).to receive(:new).and_return(image_double) }

  describe "#image_alt" do
    it { expect(image_alt(path)).to eq(alt) }
  end

  describe "#image_args" do
    it { expect(image_args(path)).to eq([path, args]) }
  end
end
