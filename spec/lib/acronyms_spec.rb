require "rails_helper"
require "acronyms"

describe Acronyms, type: :helper do
  let(:content) { "All prices include VAT except where marked exVAT" }
  let(:abbreviations) { { "VAT" => "Value added tax" } }

  subject { described_class.new(content, abbreviations).render }
  it { is_expected.to match "marked exVAT" }
  it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

  context "with HTML content" do
    let(:content) { "<a href=\"#vat\" title=\"VAT information\">VAT</a>" }
    it { is_expected.to have_css "a abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to have_css "a[title=\"VAT information\"]" }
  end

  context "with unknown abbreviation" do
    let(:content) { "<p>Payments are deducted as part of PAYE</p>" }
    it { is_expected.to have_css "p", text: "Payments are deducted as part of PAYE" }
  end
end
