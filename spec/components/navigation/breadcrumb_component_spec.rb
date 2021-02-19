require "rails_helper"

describe Navigation::BreadcrumbComponent, type: "component" do
  let(:under_hero) { false }

  subject! do
    component = described_class.new(under_hero: under_hero)
    render_inline(component) do
      controller = component.controller
      controller.breadcrumb "Page 1", "/page/1"
      controller.breadcrumb "Page 2", "/page/2"
      controller.breadcrumb "Page 3", "/page/3"
      controller.breadcrumb "Current Page", controller.request.path
    end
    page
  end

  it { is_expected.to have_css(".container.container--narrow") }
  it { is_expected.to have_css("nav.breadcrumb") }
  it { is_expected.not_to have_css("nav.breadcrumb--hero") }
  it { is_expected.not_to have_text("Current Page") }

  it "links to all previous pages" do
    expect(subject).to have_css("ol") do |ol|
      expect(ol).to have_link("Page 1", href: "/page/1")
      expect(ol).to have_link("Page 2", href: "/page/2")
      expect(ol).to have_link("Page 3", href: "/page/3")
    end
  end

  context "when under a hero component" do
    let(:under_hero) { true }

    it { is_expected.to have_css("nav.breadcrumb.breadcrumb--hero") }
  end
end
