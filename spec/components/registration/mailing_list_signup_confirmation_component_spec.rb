require "rails_helper"

describe Registration::MailingListSignupConfirmationComponent, type: :component do
  subject! { render_inline(component) }

  let(:mailing_list_session) { { "first_name" => "Joey" } }

  let(:component) { described_class.new(mailing_list_session) }

  specify "renders a button-style link to the welcome guide" do
    expect(Capybara.string(rendered_component)).to have_link("Continue your journey", href: "/welcome")
  end

  describe "#heading_text" do
    subject { component }

    context "when the mailing_list_session has a first_name" do
      specify "the header includes the first name" do
        expect(subject.heading_text).to eql("Joey, you're signed up")
      end
    end

    context "when the mailing_list_session has no first_name" do
      let(:mailing_list_session) { {} }

      specify "the header is generic" do
        expect(subject.heading_text).to eql("You've signed up")
      end
    end
  end
end
