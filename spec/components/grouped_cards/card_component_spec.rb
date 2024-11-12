require "rails_helper"

describe GroupedCards::CardComponent, type: "component" do
  subject { render_inline(instance) && page }

  let(:instance) { described_class.new organisation }
  let(:base_organisation) do
    {
      "header" => "First organisation",
      "name" => "Joe Bloggs",
      "telephone" => "01234 567890",
      "international_phone" => "+441234567890",
      "extension" => "ext. 123",
      "email" => "joe.bloggs@first.org",
    }
  end
  let(:organisation) { base_organisation }

  it { is_expected.to have_css "h4", text: "First organisation" }
  it { is_expected.to have_css ".group__card__fields span", text: "Name" }
  it { is_expected.to have_css ".group__card__fields span", text: "Joe Bloggs" }
  it { is_expected.to have_link "joe.bloggs@first.org", href: "mailto:joe.bloggs@first.org" }
  it { is_expected.to have_link "01234 567890", href: "tel:+441234567890" }
  it { is_expected.to have_css ".group__card__fields span", text: "ext. 123" }

  it { is_expected.not_to have_css "a h4" }

  context "with link" do
    let(:organisation) do
      base_organisation.tap do |h|
        h["link"] = "https://education.gov.uk"
      end
    end

    it { is_expected.to have_link href: "https://education.gov.uk" }
    it { is_expected.to have_css "a h4", text: "First organisation" }
    it { is_expected.to have_link "joe.bloggs@first.org", href: "mailto:joe.bloggs@first.org" }
  end

  context "with a status" do
    let(:organisation) do
      base_organisation.tap do |h|
        h["status"] = "Course full"
      end
    end

    it { is_expected.to have_css "p strong", text: organisation["status"] }
  end
end
