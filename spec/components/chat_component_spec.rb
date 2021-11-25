require "rails_helper"

describe ChatComponent, type: "component" do
  subject do
    render_inline(described_class.new)
    page
  end

  it { is_expected.to have_css(".chat[data-controller=chat]") }
  it { is_expected.to have_css("[data-chat-target=online].hidden") }
  it { is_expected.to have_css("[data-chat-target=online] a[data-chat-target=chat]") }
  it { is_expected.to have_css("[data-chat-target=online] a[data-action='chat#start']") }
  it { is_expected.to have_css("[data-chat-target=offline].hidden") }
  it { is_expected.to have_css("[data-chat-target=unavailable]:not(.hidden)") }
  it { is_expected.to have_css("[data-chat-target=unavailable] a[href='mailto:getintoteaching.getintoteaching@education.gov.uk']") }
end
