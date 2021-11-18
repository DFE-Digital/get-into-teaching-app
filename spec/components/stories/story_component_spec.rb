require "rails_helper"

describe Stories::StoryComponent, type: "component" do
  subject do
    render_inline(described_class.new(front_matter))
    page
  end

  let(:default_front_matter) do
    {
      "title" => "Swapping senior management for students",
      "image" => "media/images/content/stories/stories-karen.jpg",
      "story" => {
        "teacher" => "Karen Roberts",
        "video" => "https://www.youtube.com/embed/riY-1DUkLVk",
        "position" => "languages teacher",
      },
      "more_stories" => [
        {
          "name" => "Zainab",
          "snippet" => "School experience helped me decide to switch",
          "image" => "media/images/content/stories/stories-zainab.jpg",
          "link" => "/life-as-a-teacher/my-story-into-teaching/career-changers/school-experience-helped-me-decide-to-switch",
        },
        {
          "name" => "Katie",
          "snippet" => "Returning to teach with international experience",
          "image" => "media/images/content/stories/stories-katie.png",
          "link" => "/life-as-a-teacher/my-story-into-teaching/international-career-changers/returning-to-teaching-with-international-experience",
        },
        {
          "name" => "Helen",
          "snippet" => "Lawyer to assistant headteacher",
          "image" => "media/images/content/stories/stories-helen.jpg",
          "link" => "/life-as-a-teacher/my-story-into-teaching/career-progression/lawyer-to-assistant-teacher",
        },
      ],
      "build_layout_from_frontmatter" => true,
    }
  end

  let(:front_matter) { default_front_matter }

  describe "layout elements" do
    it { is_expected.to have_css(".container .markdown") }
    it { is_expected.to have_css(".container .feature") }
  end

  describe "metadata content" do
    specify "renders a story" do
      is_expected.to have_css("article.story")
    end

    specify "the story's title forms the main heading" do
      is_expected.to have_css("h1", text: front_matter["title"])
    end

    specify "the story's image is rendered" do
      is_expected.to have_css(%(img[src*="/packs-test/v1/media/images/content/stories/stories-karen"]))
    end

    specify "the teacher name and position are in secondary heading" do
      [front_matter.dig("story", "teacher"), front_matter.dig("story", "position")].each do |part|
        is_expected.to have_css("h2", text: Regexp.new(part))
      end
    end
  end

  describe "video" do
    let(:video_url) { "https://www.youtube.com/embed/riY-1DUkLVk" }
    let(:video_story) do
      { story: { "teacher" => "Karen Roberts", "video" => video_url, "position" => "languages teacher" } }
    end

    let(:front_matter) { default_front_matter.merge(video_story) }

    specify "the video iframe is present in the document and the src is correct" do
      is_expected.to have_css("iframe[data-src='#{video_url}'].lazyload")
    end
  end

  describe "more information" do
    let(:text) { "Really interesting stuff" }
    let(:link) { "/really-interesting-stuff" }
    let(:more_information) { { "more_information" => { "link" => link, "text" => text } } }
    let(:front_matter) { default_front_matter.merge(more_information) }

    specify "the link is present in the document" do
      is_expected.to have_link(text, href: link)
    end
  end

  describe "content" do
    subject do
      render_inline(described_class.new(front_matter)) do
        content
      end

      page
    end

    let(:content) { "The quick brown fox" }

    specify "the content is rendered" do
      is_expected.to have_content(content)
    end
  end

  describe "more stories" do
    context "when there are more stories" do
      specify "there is a more stories header" do
        is_expected.to have_css("h2", text: "More stories")
      end

      specify "there should be a story card for each story" do
        is_expected.to have_css(".cards.stories > .card", count: front_matter["more_stories"].length)
      end
    end

    context "when there are no more stories" do
      let(:front_matter) { default_front_matter.merge("more_stories" => nil) }

      specify "there is no more stories header" do
        is_expected.not_to have_css("h2", text: "More stories")
      end
    end
  end

  describe "explore" do
    context "when there are is explore frontmatter" do
      let(:explore) do
        default_front_matter["more_stories"].map { |s| s.merge("header" => "Test") }
      end

      let(:front_matter) { default_front_matter.merge("explore" => explore) }

      specify "there is an explore header" do
        is_expected.to have_css "section.cards-with-headers h2"
      end

      specify "cards will render without borders" do
        is_expected.to have_css "section.cards-with-headers .cards .card--no-border"
      end

      specify "cards will render with headers" do
        is_expected.to have_css "section.cards-with-headers .cards header"
      end
    end

    context "when there is no explore frontmatter" do
      specify "there should not be an explore section" do
        is_expected.not_to have_css("section.cards-with-headers")
      end
    end
  end

  describe "with page_data" do
    let(:page_data) { Pages::Data.new }
    let(:more_stories) { front_matter["more_stories"].length }

    specify "renders a story" do
      is_expected.to have_css("article.story")
    end

    specify "there should be a story card for each story" do
      is_expected.to have_css(".cards.stories > .card", count: more_stories)
    end
  end
end
