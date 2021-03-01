require "rails_helper"

RSpec.describe ServiceUnavailableComponent, type: :component do
  let(:title) { "test" }

  it "render the correct heading" do
    render_inline(described_class.new(service_type: title))
    expect(page).to have_text("Sorry, the #{title} service is currently unavailable")
  end
end
