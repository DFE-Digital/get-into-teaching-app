require "rails_helper"
require "acronyms"

describe Acronyms, type: :helper do
  let(:content) { "All prices include VAT except where marked exVAT" }
  let(:acronyms) { { "VAT" => "Value added tax" } }

  subject { described_class.new(content, acronyms).render }
  it { is_expected.to match "marked exVAT" }
  it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

  context "with HTML content" do
    let(:content) { "<a href=\"#vat\" title=\"VAT information\">VAT</a>" }
    it { is_expected.to have_css "a abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to have_css "a[title=\"VAT information\"]" }
  end

  context "with unknown acronym" do
    let(:content) { "<p>Payments are deducted as part of PAYE</p>" }
    it { is_expected.to have_css "p", text: "Payments are deducted as part of PAYE" }
  end

  context "with nil acronyms" do
    let(:acronyms) { nil }
    it { is_expected.to have_css "p", text: "All prices include VAT except where marked exVAT" }
  end

  context "with multiple acronyms in the same node" do
    let(:content) { "Taxes you may encounter include VAT and PAYE" }
    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to match "and PAYE" }
  end

  context "when the acronym is surrounded by brackets" do
    let(:content) { "Taxes you may encounter include Value Added Tax (VAT) and Pay as you earn (PAYE)." }
    it "remains unchanged" do
      is_expected.to match(content)
    end
  end
end
