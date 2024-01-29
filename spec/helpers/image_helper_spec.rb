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

  describe "#image_alt_attribs" do
    it { expect(image_alt_attribs(path)).to eq({ alt: alt }) }
  end

  context "with alt text" do
    describe "#image_alt_attribs_for_text" do
      it { expect(image_alt_attribs_for_text(alt)).to eq({ alt: alt }) }
    end
  end

  context "with blank alt text" do
    describe "#image_alt_attribs_for_text" do
      it { expect(image_alt_attribs_for_text("")).to eq({ alt: "", role: "presentation" }) }
    end
  end
end
