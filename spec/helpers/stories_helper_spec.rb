require "rails_helper"

describe StoriesHelper, type: "helper" do
  let(:teacher) { "Mrs Krabappel" }
  let(:position) { "4th grade teacher" }

  let(:front_matter) do
    { "story" => { "teacher" => teacher, "position" => position } }
  end

  describe "#story_heading" do
    subject { helper.story_heading(teacher, position) }

    specify %(should generate a level 2 heading containing the teacher's name and job) do
      expect(subject).to have_css("h2", text: %(#{teacher},\n#{position}))
    end
  end

  describe "#story_image_alt" do
    subject { helper.story_image_alt(name) }

    let(:name) { "David" }

    specify %(returns string 'A photograph of' followed by the supplied name) do
      is_expected.to match("A photograph of #{name}")
    end
  end

  describe "#youtube" do
    subject { helper.youtube(url) }

    let(:url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }

    specify %(should generate an iframe with the data-src attribute set to the video's URL) do
      expect(subject).to have_css(%(iframe[data-src='#{url}']), class: "story__video lazyload")
    end
  end

  describe "#more_stories_thumbnail" do
    subject { helper.more_stories_thumbnail(path) }

    let(:path) { "/assets/mugshots/elizabeth_hoover.jpg" }

    specify %(should generate a div with the background image set to the provided path) do
      expect(subject).to have_css(%(div[style="background-image:url('#{path}')"]), class: "stories__thumbs__thumb__img")
    end
  end
end
