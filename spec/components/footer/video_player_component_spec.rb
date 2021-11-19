require "rails_helper"

describe Footer::VideoPlayerComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:video_component_selector) { ".video-overlay" }

  specify "renders the video player component" do
    expect(page).to have_css(video_component_selector)
  end

  specify "the content is present" do
    expect(page).to have_content(/Close video/)
  end
end
