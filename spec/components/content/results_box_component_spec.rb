require "rails_helper"

describe Content::ResultsBoxComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:heading) { "Postgraduate Initial Teacher Training with fees" }
  let(:fee) { "Yes" }
  let(:course_length) { "9 months (full-time) or up to 2 years (part-time)" }
  let(:funding) { "Scholarships or bursaries, as well as student loans, are available if you're eligible" }
  let(:text) { "Find out which qualifications you need, what funding you can get and how to train to teach." }
  let(:title) { nil }
  let(:border_color) { :grey }
  let(:link_text) { "Find out more about postgraduate initial teacher training" }
  let(:link_target) { "/train-to-be-a-teacher" }

  let(:component) do
    described_class.new(
      heading: heading,
      fee: fee,
      course_length: course_length,
      funding: funding,
      text: text,
      title: title,
      border_color: border_color,
      link_text: link_text,
      link_target: link_target,
    )
  end

  it { is_expected.to have_css(".results-box .results-box__heading") }
  it { is_expected.to have_css(".results-box__full-width-text", text: text) }
  it { is_expected.to have_css(".results-box__value", text: fee) }
  it { is_expected.to have_css(".results-box__value", text: course_length) }
  it { is_expected.to have_css(".results-box__value", text: funding) }
  it { is_expected.to have_css(".results-box--grey") }
  it { is_expected.to have_no_css(".results-box__title", text: title) }

  context "when a title is provided" do
    let(:title) { "Most popular route" }

    it { is_expected.to have_css(".results-box__title", text: title) }
  end

  context "when the border color is yellow" do
    let(:border_color) { :yellow }

    it { is_expected.to have_css(".results-box--yellow") }
  end
end
