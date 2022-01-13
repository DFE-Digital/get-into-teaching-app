require "rails_helper"
require "acronyms"

describe Acronyms, type: :helper do
  subject { described_class.new(content, acronyms).render }

  let(:content) { "<p>All prices include VAT except where marked exVAT</p>" }
  let(:acronyms) { { "VAT" => "Value added tax", "HMRC" => "Her Majesty's Revenue and Customs" } }

  it { is_expected.to match "marked exVAT" }
  it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }

  context "with HTML content" do
    let(:content) { "<p id=\"#vat\" title=\"VAT information\">VAT</p>" }

    it { is_expected.to have_css "p abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to have_css "p[title=\"VAT information\"]" }
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
    let(:content) { "<p>Taxes you may encounter include VAT and PAYE</p>" }

    it { is_expected.to have_css "abbr[title=\"Value added tax\"]", text: "VAT" }
    it { is_expected.to match "and PAYE" }
  end

  context "when the acronym is surrounded by brackets" do
    let(:content) { "Taxes you may encounter include Value Added Tax (VAT) and Pay as you earn (PAYE)." }

    it "remains unchanged" do
      is_expected.to match(content)
    end
  end

  describe "only applies the substitution in <p> tags" do
    { span: 0, div: 0, article: 0, a: 0, p: 2 }.each do |tag, count|
      context "tag: #{tag}" do
        let(:content) { "<#{tag}>HMRC have a new VAT system</#{tag}>" }

        if count > 0
          it { is_expected.to have_css("abbr", count: count) }
        else
          it { is_expected.not_to have_css("abbr") }
        end
      end
    end
  end
end
