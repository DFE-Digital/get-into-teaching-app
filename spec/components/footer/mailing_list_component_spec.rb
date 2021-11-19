require "rails_helper"

describe Footer::MailingListComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:mailing_list_selector) { ".mailing-list-bar" }

  specify "renders the mailing list component" do
    expect(page).to have_css(mailing_list_selector)
  end

  specify "the content is present" do
    expect(page).to have_content(/we'll send you all the information you need/)
  end
end
