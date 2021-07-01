require "rails_helper"

describe Header::NavigationComponent, type: "component" do
  # these are built from the markdown frontmatter
  let(:resources) do
    [OpenStruct.new(path: "/one", title: "One"), OpenStruct.new(path: "/two", title: "Two")]
  end

  # these are passed in as an arg and represent pages that aren't Markdown
  let(:extra_resources) do
    { "/three" => "Three", "/four" => "Four" }
  end

  let(:component) { described_class.new(resources: resources, extra_resources: extra_resources) }
  subject! { render_inline(component) }

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

  describe "rendering menus" do
    let(:children) do
      [
        OpenStruct.new(path: "/five/part-one", title: "Five: part one"),
        OpenStruct.new(path: "/five/part-two", title: "Five: part two"),
      ]
    end

    let(:resources) do
      [OpenStruct.new(path: "/five", title: "Five", menu?: true, children: children)]
    end

    let(:component) { described_class.new(resources: resources) }

    subject! { render_inline(component) }

    specify "the secondary navigatoin has right number of links" do
      expect(page).to have_css("ol.primary > li > ol.secondary > li", count: children.size)
    end

    specify "the links have the right titles and hrefs" do
      children.each do |child|
        expect(page).to have_link(child.title, href: child.path)
      end
    end
  end
end
