require "rails_helper"

describe BlogHelper, type: "helper" do
  describe "#format_blog_date" do
    subject { format_blog_date(markdown_date) }

    let(:markdown_date) { "2019-03-04" }

    specify "formats the date in the GOV.UK short style" do
      expect(subject).to eql("4 March 2019")
    end
  end

  describe "#first_image_from_post" do
    let(:images) do
      {
        "first" => { "path" => "one.jpg", "alt" => "a nice image" },
        "second" => { "path" => "two.jpg", "alt" => "a nicer image" },
      }
    end

    specify "initializes an Content::ImageComponent with the attributes from the first image" do
      image_component = class_double("Content::ImageComponent").as_stubbed_const

      expect(image_component).to receive(:new).with(path: "one.jpg", alt: "a nice image").and_return(inline: "doesn't matter")

      first_image_from_post(images)
    end
  end
end
