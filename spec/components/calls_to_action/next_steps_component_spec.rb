require "rails_helper"

RSpec.describe CallsToAction::NextStepsComponent, type: :component do
  let(:component) { CallsToAction::NextStepsComponent.new }
  before { render_inline(component) }

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action.call-to-action--next-steps")
  end
end
