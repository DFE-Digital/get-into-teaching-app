require "rails_helper"

describe Navbar::NavbarComponent, type: "component" do
  let(:all_frontmatter) do
    { "/mock-path" => { title: "Mock title", navigation: 20 } }
  end

  before do
    allow(Pages::Frontmatter).to receive(:list).and_return all_frontmatter
  end

  subject! { render_inline(Navbar::NavbarComponent.new(all_frontmatter)) }

  describe "Desktop navbar component" do
    context "when rendered" do
      it "shows background colour on link that matches the current page" do
        desktop_navbar = page.find(".navbar__desktop")
        home_link = desktop_navbar.find("a", text: "Home")
        parent_li = home_link.find(:xpath, "..")

        expect(parent_li["class"]).to match("active")
      end

      it "shows no background colour on links that do not match the current page" do
        desktop_navbar = page.find(".navbar__desktop")
        home_links = desktop_navbar.all("a").reject do |anchor|
          anchor.native.children.text == "Home"
        end
        parent_lis = []
        home_links.each { |anchor| parent_lis.push(anchor.find(:xpath, "..")) }

        parent_lis.each do |li|
          expect(li["class"]).to_not match("active")
        end
      end
    end
  end
end
