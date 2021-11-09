require "rails_helper"

describe BlogHelper, type: "helper" do
  describe "#format_blog_date" do
    subject { format_blog_date(markdown_date) }

    let(:markdown_date) { "2019-03-04" }

    specify "formats the date in the GOV.UK short style" do
      expect(subject).to eql("4 March 2019")
    end
  end

  describe "#thumbnail_image_from_post" do
    let(:image_component) { class_double("Content::ImageComponent").as_stubbed_const }
    let(:images) do
      {
        "first" => { "path" => "one.jpg", "alt" => "a nice image" },
        "second" => { "path" => "two.jpg", "alt" => "a nicer image" },
      }
    end

    specify "initializes an Content::ImageComponent with the attributes from the first image" do
      expect(image_component).to receive(:new).with(path: "one.jpg", alt: "a nice image").and_return(inline: "doesn't matter")

      thumbnail_image_from_post(images)
    end

    context "when the first image has a thumbnail_path" do
      before do
        images["first"]["thumbnail_path"] = "thumbnail.jpg"
      end

      specify "initializes an Content::ImageComponent with the thumbnail_path" do
        expect(image_component).to receive(:new).with(path: "thumbnail.jpg", alt: "a nice image").and_return(inline: "doesn't matter")

        thumbnail_image_from_post(images)
      end
    end
  end
end
