require "rails_helper"

describe Cards::ChatOnlineComponent, type: "component" do
  subject { render_inline(instance) && page }

  around do |example|
    travel_to(time.in_time_zone("London")) { example.run }
  end

  let(:instance) { described_class.new card: {} }
  let(:time) { Time.zone.local(2021, 1, 1, 12, 30) }

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.to have_css ".card header", text: "Get the answers you need" }
  it { is_expected.to have_css "img[alt='A photograph of a child with their hand raised']" }
  it { is_expected.to have_content "Chat online with one of our teacher training experts" }
  it { is_expected.to have_css("div[data-controller=chat]", text: "Chat online") }
end
