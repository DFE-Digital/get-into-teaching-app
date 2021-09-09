require "rails_helper"
require "acronyms"

describe Acronyms, type: :helper do
  subject { described_class.new(content, acronyms).render }

  let(:content) { "All prices include VAT except where marked exVAT" }
  let(:acronyms) { { "VAT" => "Value added tax", "HMRC" => "Her Majesty's Revenue and Customs" } }

  it { is_expected.to match "marked exVAT" }
  it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

  context "with HTML content" do
    let(:content) { "<span id=\"#vat\" title=\"VAT information\">VAT</span>" }

    it { is_expected.to have_css "span abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to have_css "span[title=\"VAT information\"]" }
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

  context "when the acronym is within a hyperlink" do
    let(:content) { "<span><a href=\"#hmrc\" title=\"Her Majesty's Revenue and Customs\">HMRC</a> have a new VAT system</span>" }

    it { is_expected.to have_css("abbr", count: 1) }
    it { is_expected.not_to have_css("abbr", text: "HMRC") }
  end
end
