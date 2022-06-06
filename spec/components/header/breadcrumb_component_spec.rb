require "rails_helper"

describe Header::BreadcrumbComponent, type: "component" do
  subject! do
    component = described_class.new

    controller.breadcrumb "Page 1", "/page/1"
    controller.breadcrumb "Page 2", "/page/2"
    controller.breadcrumb "Page 3", "/page/3"
    controller.breadcrumb "Current Page", controller.request.path

    render_inline(component)
    page
  end

  it { is_expected.to have_css(".container.breadcrumbs") }
  it { is_expected.to have_css("nav.govuk-breadcrumbs") }
  it { is_expected.to have_text("Current Page") }

  it "links to all previous pages" do
    expect(subject).to have_css("ol") do |ol|
      expect(ol).to have_link("Page 1", href: "/page/1")
      expect(ol).to have_link("Page 2", href: "/page/2")
      expect(ol).to have_link("Page 3", href: "/page/3")
      expect(ol).not_to have_link("Current Page")
    end
  end
end
