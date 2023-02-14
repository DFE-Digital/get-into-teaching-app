require "rails_helper"

describe Content::MailingListComponent, type: :component do
  include_context "with stubbed latest privacy policy api"

  subject(:render) do
    render_inline(component)
    page
  end

  let(:component) { described_class.new }

  it { is_expected.to have_css(".action-container") }
  it { is_expected.to have_css("form") }
  it { is_expected.to have_link("privacy notice", href: "/privacy-policy?id=#{policy['id']}") }
end
