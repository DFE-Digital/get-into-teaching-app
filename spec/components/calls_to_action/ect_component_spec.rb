require "rails_helper"

RSpec.describe CallsToAction::EctComponent, type: :component do
  subject! { Capybara.string(component) }

  let(:component) { render_inline(described_class.new) }

  it "renders a component with information about early career and newly qualified teachers" do
    expect(subject).to have_css(".call-to-action") do |c|
      expect(c).to have_text(/early career/)
      expect(c).to have_text(/newly qualified/)
    end
  end
end
