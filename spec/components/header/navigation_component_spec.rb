require "rails_helper"

describe Header::NavigationComponent, type: "component" do
  # these are built from the markdown frontmatter
  subject! { render_inline(component) }

  let(:resources) do
    [OpenStruct.new(path: "/one", title: "One"), OpenStruct.new(path: "/two", title: "Two")]
  end

  # these are passed in as an arg and represent pages that aren't Markdown
  let(:extra_resources) do
    { "/three" => "Three", "/four" => "Four" }
  end

  let(:component) { described_class.new(resources: resources, extra_resources: extra_resources) }

  specify "renders a primary navigation list" do
    expect(page).to have_css("nav > ol.primary")
    expect(page).to have_css("nav > ol.primary > li", count: resources.size + extra_resources.size)
  end

  specify "renders all of the resources" do
    resources.each { |r| expect(page).to have_link(r.title, href: r.path) }
    extra_resources.each { |path, title| expect(page).to have_link(title, href: path) }
  end

  specify "extra resources are last" do
    expect(component.all_resources.map(&:title)).to end_with(extra_resources.values)
  end
end
