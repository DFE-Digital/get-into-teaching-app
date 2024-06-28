require "rails_helper"

describe Content::StepsComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:numeric) { true }
  let(:steps) do
    {
      "Step 1" => { partial: "/content/home/test_content" },
      "Step 2" => { partial: "/content/home/test_content" },
    }
  end
  let(:component) { described_class.new(steps: steps, numeric: numeric) }

  it { is_expected.to have_css("ol.steps") }
  it { is_expected.to have_css("ol.steps li", count: steps.count) }

  it "renders steps" do
    steps.each.with_index do |(title, _contents), idx|
      within(render.all("li")[idx]) do
        it { is_expected.to have_css(".step__number", text: idx) }
        it { is_expected.to have_css("h2", text: title) }
        it { is_expected.to have_css("span", text: "Check your qualifications") }
      end
    end
  end

  context "when numeric is false" do
    let(:numeric) { false }

    it { is_expected.to have_css("ul.steps") }
    it { is_expected.to have_css(".step__number img") }
  end
end
