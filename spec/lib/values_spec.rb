require "rails_helper"

RSpec.describe Values do
  subject(:values) { Class.new { include Values }.new }

  describe "#value" do
    it "looks up the value by key" do
      allow(Value).to receive(:get).with("bursary").and_return("£5,000")

      expect(values.value("bursary")).to eq("£5,000")
    end
  end

  describe "#v" do
    it "is an alias for #value" do
      allow(Value).to receive(:get).with("bursary").and_return("£5,000")

      expect(values.v("bursary")).to eq("£5,000")
    end
  end

  describe "#substitute_values" do
    it "returns non-string content unchanged" do
      content = { amount: "£5,000" }

      expect(values.substitute_values(content)).to equal(content)
    end

    it "substitutes each placeholder with its configured value" do
      allow(Value).to receive(:get).with("bursary").and_return("£5,000")
      allow(Value).to receive(:get).with("scholarship").and_return("£10,000")

      expect(values.substitute_values("Get a bursary of $bursary$ or a scholarship of $scholarship$.")).to eq("Get a bursary of £5,000 or a scholarship of £10,000.")
    end

    it "supports hyphens in placeholder keys" do
      allow(Value).to receive(:get).with("postgraduate-bursary").and_return("£5,000")

      expect(values.substitute_values("Get $postgraduate-bursary$.")).to eq("Get £5,000.")
    end

    it "replaces an unknown placeholder with an empty string" do
      expect(values.substitute_values("Before $unknown$ after")).to eq("Before  after")
    end

    it "keeps ordinary strings HTML-unsafe" do
      result = values.substitute_values("<strong>Untrusted content</strong>")

      expect(result).not_to be_html_safe
    end

    it "preserves HTML safety for content that was already marked safe" do
      content = "<!-- BEGIN component -->Bursaries<!-- END component -->".html_safe

      result = values.substitute_values(content)

      expect(result).to be_html_safe
      expect(result).to eq(content)
    end

    it "preserves HTML safety when substituting into safe content" do
      allow(Value).to receive(:get).with("bursary").and_return("£5,000")
      content = "<strong>$bursary$</strong>".html_safe

      result = values.substitute_values(content)

      expect(result).to be_html_safe
      expect(result).to eq("<strong>£5,000</strong>")
    end
  end
end
