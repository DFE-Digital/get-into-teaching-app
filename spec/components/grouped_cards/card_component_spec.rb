require "rails_helper"

describe GroupedCards::CardComponent, type: "component" do
  subject { render_inline(instance) && page }

  let(:instance) { described_class.new organisation }
  let(:organisation) do
    {
      "header" => "First organisation",
      "name" => "Joe Bloggs",
      "telephone" => "01234 567890 (ext 123)",
      "email" => "joe.bloggs@first.org",
    }
  end

  it { is_expected.to have_css "h4", text: "First organisation" }
  it { is_expected.to have_css ".group__card__fields span", text: "Name" }
  it { is_expected.to have_css ".group__card__fields span", text: "Joe Bloggs" }
  it { is_expected.to have_link "joe.bloggs@first.org", href: "mailto:joe.bloggs@first.org" }

  it { is_expected.not_to have_css "a h4" }

  context "with link" do
    let(:organisation) do
      {
        "header" => "First organisation",
        "link" => "https://education.gov.uk",
        "name" => "Joe Bloggs",
        "email" => "joe.bloggs@first.org",
      }
    end

    it { is_expected.to have_link href: "https://education.gov.uk" }
    it { is_expected.to have_css "a h4", text: "First organisation" }
    it { is_expected.to have_link "joe.bloggs@first.org", href: "mailto:joe.bloggs@first.org" }
  end
end
