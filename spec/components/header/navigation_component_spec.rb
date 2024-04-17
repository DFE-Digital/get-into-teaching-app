require "rails_helper"

describe Header::NavigationComponent, type: "component" do
  # these are built from the markdown frontmatter
  subject! { render_inline(component) }

  let(:primary_nav) do
    {
      "/page-one" => { title: "Page one", navigation: 1 },
      "/page-two" => { title: "Page two", navigation: 2 },
      "/page-three" => { title: "Page three", navigation: 3 },
      "/page-four" => { title: "Page four", navigation: 4 },
      "/page-five" => { title: "Page five", navigation: 5, menu: true },
      "/page-six" => { title: "Page six", navigation: 6, menu: true },
      "/page-seven" => { title: "Page seven", navigation: 7 },
    }
  end

  let(:page_five_subpages) do
    {
      "/page-five/part-1" => { title: "Page five: part 1", subcategory: "category 1", navigation: 5.1 },
      "/page-five/part-2" => { title: "Page five: part 2", subcategory: "category 1", navigation: 5.2 },
      "/page-five/part-3" => { title: "Page five: part 3", subcategory: "category 2", navigation: 5.3 },
    }
  end

  let(:resources) do
    Pages::Navigation.new(primary_nav.merge(page_five_subpages)).nodes
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

  it "renders a dropdown menu for category links" do
    expect(page).to have_css("#secondary-navigation > div.category-links > ol.category-links-list > li[id='page-five-category-1-desktop'] > a")
    expect(page).to have_css("#secondary-navigation > div.category-links > ol.category-links-list > li[id='page-five-category-2-desktop'] > a")
  end

  it "renders a dropdown menu for page links" do
    expect(page).to have_css("#secondary-navigation > div.page-links > ol.page-links-list > li[id='page-five-part-1-desktop'] > a")
    expect(page).to have_css("#secondary-navigation > div.page-links > ol.page-links-list > li[id='page-five-part-2-desktop'] > a")
    expect(page).to have_css("#secondary-navigation > div.page-links > ol.page-links-list > li[id='page-five-part-3-desktop'] > a")
  end

  it "renders a view all link" do
    expect(page).to have_css("#secondary-navigation > div.category-links > ol.category-links-list > li[data-id='menu-view-all-page-five'] > a")
  end
end
