require "rails_helper"

describe Content::Subject::TeachingPupilsComponent, type: :component do
  let(:component) { described_class.new }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("div.teaching-pupils") }
  it { is_expected.to have_css("p") }
  it { expect { render_inline(component) }.not_to raise_error }
end
