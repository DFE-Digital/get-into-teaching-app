require "rails_helper"

describe Image do
  describe "class_methods" do
    before { described_class.image_data }

    it { is_expected.to respond_to(:image_data) }

    specify "sets image_data class variable" do
      expect(described_class.class_variable_get(:@@image_data)).to be_a(Hash)
    end
  end

  describe "methods" do
    describe "#build_args" do
      subject { described_class.new.build_args(path) }

      context "with a valid image path" do
        let(:path) { "media/images/content/hero-images/0003.jpg" }

        specify "returns the correct image path and alt text" do
          expect(subject).to eql([path, { alt: "Male and female teacher talking in a staff room." }])
        end
      end

      context "with a bad image path" do
        let(:path) { "media/something-really-invalid/abc.pdf" }

        specify "raises an error" do
          expect { subject }.to raise_error(Image::UnregisteredImageError, /no image information found/)
        end
      end
    end

    describe "#alt" do
      subject { described_class.new.alt(path) }

      context "with a valid image path" do
        let(:path) { "media/images/content/hero-images/0003.jpg" }

        specify "returns the correct image path and alt text" do
          expect(subject).to eql("Male and female teacher talking in a staff room.")
        end
      end

      context "with a bad image path" do
        let(:path) { "media/something-really-invalid/abc.pdf" }

        specify "raises an error" do
          expect { subject }.to raise_error(Image::UnregisteredImageError, /no image information found/)
        end
      end
    end
  end

  describe "delegation" do
    it { is_expected.to delegate_method(:image_data).to(:class) }
  end
end
