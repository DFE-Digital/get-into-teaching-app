require "rails_helper"

describe Header::NavigationComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  specify { expect(page).to have_css("nav > ol.primary") }
end
