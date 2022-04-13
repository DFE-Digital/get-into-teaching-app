require "rails_helper"

describe Content::FeatureTableComponent, type: "component" do
  subject! do
    render_inline(described_class.new(data, title))
    page
  end

  let(:title) { "Features" }
  let(:data) do
    {
      "Feature 1" => "Value 1",
      "Feature 2" => "Value 2",
      "Feature 3" => "Value 3",
    }
  end

  it { is_expected.to have_css(".feature-table") }
  it { is_expected.to have_css("h3##{title.parameterize}-table", text: title) }
  it { is_expected.to have_css("dl") }

  describe "within the definition list" do
    it "displays headings" do
      data.each_key { |heading| expect(page).to have_css("dl dt", text: heading) }
    end

    it "displays values" do
      data.each_value { |value| expect(page).to have_css("dl dd", text: value) }
    end
  end

  it "raises an error when data is nil" do
    expect { described_class.new(nil) }.to raise_error(ArgumentError, /data must be present/)
  end

  it "raises an error when data is an empty hash" do
    expect { described_class.new({}) }.to raise_error(ArgumentError, /data must be present/)
  end

  context "when title is nil" do
    let(:title) { nil }

    it { is_expected.not_to have_css("h3") }
  end

  context "when title is empty" do
    let(:title) { " " }

    it { is_expected.not_to have_css("h3") }
  end

  context "when heading tag is overridden" do
    subject! do
      render_inline(described_class.new(data, title, heading_tag: "h2"))
      page
    end

    it { is_expected.to have_css("h2", text: title) }
  end
end
