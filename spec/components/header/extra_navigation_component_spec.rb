require "rails_helper"

describe Header::ExtraNavigationComponent, type: "component" do
  subject! { render_inline(component) }

  let(:custom_class) { "red-bg" }
  let(:component) { described_class.new(classes: Array.wrap(custom_class)) }

  specify "renders the extra navigation container with contents" do
    expect(page).to have_css(".extra-navigation") do |en|
      expect(en).to have_css("ul.extra-navigation__list.extra-navigation__flex > li", count: 2)
    end
  end

  specify "applies the custom classes" do
    expect(page).to have_css(".extra-navigation.#{custom_class}")
  end
end
