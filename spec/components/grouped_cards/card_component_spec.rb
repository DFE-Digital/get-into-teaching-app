require "rails_helper"

describe GroupedCards::CardComponent, type: "component" do
  subject { render_inline(instance) && page }

  let(:instance) { described_class.new organisation }
  let(:organisation) do
    {
      header: "First organisation",
      name: "Joe Bloggs",
      telephone: "01234 567890 (ext 123)",
      email: "joe.bloggs@first.org",
    }.with_indifferent_access
  end

  it { is_expected.to have_css "h4", text: "First organisation" }
  it { is_expected.to have_css ".event-box__datetime span", text: "Name" }
  it { is_expected.to have_css ".event-box__datetime span", text: "Joe Bloggs" }
  it { is_expected.to have_link "joe.bloggs@first.org", href: "mailto:joe.bloggs@first.org" }
end
