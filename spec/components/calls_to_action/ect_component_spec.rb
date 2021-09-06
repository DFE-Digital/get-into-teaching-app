require "rails_helper"

RSpec.describe CallsToAction::EctComponent, type: :component do
  before do
    render_inline(described_class.new)
  end

  subject! { Capybara.string(rendered_component) }

  it "renders a component with information about early career and newly qualified teachers" do
    expect(subject).to have_css(".call-to-action") do |component|
      expect(component).to have_text(/early career/)
      expect(component).to have_text(/newly qualified/)
    end
  end
end
