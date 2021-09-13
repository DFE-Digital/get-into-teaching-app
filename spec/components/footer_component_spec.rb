require "rails_helper"

describe FooterComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:feedback_selector) { ".feedback-bar" }
  let(:talk_to_us_selector) { ".talk-to-us" }
  let(:mailing_list_selector) { ".mailing-list-bar" }

  specify "renders the footer" do
    expect(page).to have_css(".site-footer")
  end

  specify "renders the 'Feedback bar' by default" do
    expect(page).to have_css(feedback_selector)
  end

  specify "renders the 'Talk To Us' section by default" do
    expect(page).to have_css(talk_to_us_selector)
  end

  specify "renders the 'Mailing list' section by default" do
    expect(page).to have_css(mailing_list_selector)
  end

  specify "renders the video player overlay" do
    expect(page).to have_css(".video-overlay")
  end

  specify "renders the cookie acceptance popup" do
    expect(page).to have_css(".cookie-acceptance")
  end

  context "when feedback is disabled" do
    subject! { render_inline(described_class.new(feedback: false)) }

    specify "does not render the feedback bar" do
      expect(page).not_to have_css(feedback_selector)
    end
  end

  context "when 'Talk to us' is disabled" do
    subject! { render_inline(described_class.new(talk_to_us: false)) }

    specify "does not render the 'Talk to us' section" do
      expect(page).not_to have_css(talk_to_us_selector)
    end
  end

  context "when 'Mailing list bar' is disabled" do
    subject! { render_inline(described_class.new(mailing_list: false)) }

    specify "does not render the 'Mailing list bar' section" do
      expect(page).not_to have_css(mailing_list_selector)
    end
  end

  context "when a lid_pixel_event is supplied" do
    subject! { render_inline(described_class.new(lid_pixel_event: event)) }

    let(:event) { "Success" }

    specify "renders the right analytics element" do
      expect(rendered_component).to include_analytics("lid", { action: "track", event: event })
    end
  end

  describe "Zendesk Chat snippet" do
    subject! do
      allow(Rails.application.config.x).to receive(:zendesk_chat) { enabled }
      render_inline(described_class.new)
    end

    context "when disabled" do
      let(:enabled) { false }

      it { expect(page).not_to have_css("script#ze-snippet", visible: :all) }
    end

    context "when enabled" do
      let(:enabled) { true }

      it { expect(page).to have_css("script#ze-snippet[src='https://static.zdassets.com/ekr/snippet.js?key=34a8599c-cfec-4014-99bd-404a91839e37']", visible: :all) }
    end
  end
end
