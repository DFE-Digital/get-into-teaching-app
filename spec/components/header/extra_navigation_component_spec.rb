require "rails_helper"

describe Header::ExtraNavigationComponent, type: "component" do
  subject! { render_inline(component) }

  let(:custom_class) { "red-bg" }
  let(:custom_custom_search_input_id) { "do-a-search" }
  let(:component) { described_class.new(classes: Array.wrap(custom_class), search_input_id: custom_custom_search_input_id) }

  specify "renders the extra navigation container with contents" do
    expect(page).to have_css(".extra-navigation") do |en|
      expect(en).to have_css("ul.extra-navigation__list > li", count: 3)
    end
  end

  specify "applies the custom classes" do
    expect(page).to have_css(".extra-navigation.#{custom_class}")
  end

  specify "generates a label for the accessible select box with the supplied id" do
    expect(page).to have_css("label[for='#{custom_custom_search_input_id}']", text: "Search")
  end
end
