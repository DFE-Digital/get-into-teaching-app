require "rails_helper"

describe StoriesHelper, type: "helper" do
  let(:teacher) { "Mrs Krabappel" }
  let(:position) { "4th grade teacher" }

  let(:front_matter) do
    { "story" => { "teacher" => teacher, "position" => position } }
  end

  describe "#story_heading" do
    subject { helper.story_heading(front_matter) }

    specify %(should generate a level 2 heading containing the teacher's name and job) do
      expect(subject).to have_css("h2", text: %(#{teacher},#{position}))
    end
  end

  describe "#youtube" do
    let(:url) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    subject { helper.youtube(url) }

    specify %(should generate an iframe with the src attribute set to the video's URL) do
      expect(subject).to have_css(%(iframe[src='#{url}']), class: "story__video")
    end
  end

  describe "#more_stories_thumbnail" do
    let(:path) { "/assets/mugshots/elizabeth_hoover.jpg" }
    subject { helper.more_stories_thumbnail(path) }

    specify %(should generate a div with the background image set to the provided path) do
      expect(subject).to have_css(%(div[style="background-image:url('#{path}')"]), class: "more-stories__thumbs__thumb__img")
    end
  end
end
