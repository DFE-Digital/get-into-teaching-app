require "rails_helper"

describe Content::FeatureTableComponent, type: "component" do
  let(:title) { "Features" }
  let(:description) { "A description of the data" }
  let(:data) do
    {
      "Feature 1" => "Value 1",
      "Feature 2" => "Value 2",
      "Feature 3" => "Value 3",
    }
  end

  subject! do
    render_inline(described_class.new(data, description, title))
    page
  end

  it { is_expected.to have_css(".feature-table") }
  it { is_expected.to have_css("h2", text: title) }
  it { expect(page.find("table")["aria-label"]).to eq(description) }
  it { is_expected.to have_css("tbody.mobile") }
  it { is_expected.to have_css("tbody.desktop") }

  describe "within the body of the table" do
    it "displays table headings" do
      data.keys.each { |heading| expect(page).to have_css("tbody.mobile th", text: heading) }
      data.keys.each { |heading| expect(page).to have_css("tbody.desktop th", text: heading) }
    end

    it "displays table data" do
      data.values.each { |heading| expect(page).to have_css("tbody.mobile td", text: heading) }
      data.values.each { |heading| expect(page).to have_css("tbody.desktop td", text: heading) }
    end
  end

  it "raises an error when data is nil" do
    expect { described_class.new(nil, description) }.to raise_error(ArgumentError, /data must be present/)
  end

  it "raises an error when data is an empty hash" do
    expect { described_class.new({}, description) }.to raise_error(ArgumentError, /data must be present/)
  end

  it "raises an error when description is nil" do
    expect { described_class.new(data, nil) }.to raise_error(ArgumentError, /description must be present/)
  end

  it "raises an error when description is empty" do
    expect { described_class.new(data, " ") }.to raise_error(ArgumentError, /description must be present/)
  end

  context "when title is nil" do
    let(:title) { nil }

    it { is_expected.not_to have_css("h2") }
  end

  context "when title is empty" do
    let(:title) { " " }

    it { is_expected.not_to have_css("h2") }
  end
end
