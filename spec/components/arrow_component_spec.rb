require "rails_helper"

describe ArrowComponent, type: :component do
  let(:component) do
    described_class.new(
      width: 200,
      height: 200,
      x1: 0,
      y1: 0.5,
      x2: 1,
      y2: 0.5,
      cx: 0.5,
      cy: 0.1,
      arrow_size: 0.1,
    )
  end

  subject(:render) do
    render_inline(component)
    page
  end

  it "draws an SVG arrow" do
    html = render.native.to_s.gsub("\n", "")

    expected_svg = <<~SVG.gsub("\n", "")
      <svg width="200" height="200" class="arrow" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      <path d="M 0 100.0 Q 100.0 20.0 200 100.0" class="line"></path>
      <path d="M 197.2 82.8 L 200 100.0 182.8 102.8"></path>
      </svg>
    SVG

    expect(html).to include(expected_svg)
  end
end
