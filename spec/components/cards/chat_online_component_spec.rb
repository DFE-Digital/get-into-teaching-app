require "rails_helper"

describe Cards::ChatOnlineComponent, type: "component" do
  subject { render_inline(instance) && page }

  let(:instance) { described_class.new card: {} }

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.to have_css ".card header", text: "Get the answers you need" }
  it { is_expected.to have_css "img[alt='A photograph of a child with their hand raised']" }
  it { is_expected.to have_content "If you have questions" }
end
