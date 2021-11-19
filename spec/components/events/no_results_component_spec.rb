require "rails_helper"

describe Events::NoResultsComponent, type: "component" do
  subject do
    render_inline(component) { message }
    page
  end

  let(:message) { "no results message" }
  let(:component) { described_class.new }

  it { is_expected.to have_css(".no-results") }
  it { is_expected.to have_text(message) }
end
