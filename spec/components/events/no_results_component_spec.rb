require "rails_helper"

describe Events::NoResultsComponent, type: "component" do
  let(:message) { "no results message" }
  let(:component) { Events::NoResultsComponent.new }

  subject do
    render_inline(component) { message }
    page
  end

  it { is_expected.to have_css(".no-results") }
  it { is_expected.to have_text(message) }
end
