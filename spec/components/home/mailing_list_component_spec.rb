require "rails_helper"

describe Home::MailingListComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:component) { described_class.new }

  it { is_expected.to have_css(".home-mailing-list") }
  it { is_expected.to have_css("h2") }
  it { is_expected.to have_css("form") }
  it { is_expected.to have_link("privacy notice (opens in new tab)", href: "/privacy-policy?id=123") }
end
