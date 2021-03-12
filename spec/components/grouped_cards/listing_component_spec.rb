require "rails_helper"

describe GroupedCards::ListingComponent, type: "component" do
  subject { render_inline(instance) && page }

  let(:instance) { described_class.new data }
  let(:organisation) do
    {
      "header" => "First organisation",
      "name" => "Joe Bloggs",
      "telephone" => "01234567890",
      "email" => "joe.bloggs@first.org",
    }
  end
  let :data do
    {
      "Region 1" => [organisation, organisation],
      "Region 2" => [organisation],
    }
  end

  it { is_expected.to have_css "ul", count: 1 }
  it { is_expected.to have_css "ul li a", count: 2 }
  it { is_expected.to have_link "Region 1", href: "#group--region-1" }

  it { is_expected.to have_css "h3", text: "Region 1" }
  it { is_expected.to have_css "h3", text: "Region 2" }

  it { is_expected.to have_css ".group__card", count: 3 }
end
