require "rails_helper"

RSpec.describe CallsToAction::SimpleComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:title) { "Joey" }
  let(:text) { "Venenatismorbi anunc diamsuspendisse pretiumin sollicitudindonec." }
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }

  describe "rendering the component" do
    let(:kwargs) { { icon: icon, title: title, text: text, link_text: link_text, link_target: link_target } }

    let(:component) { described_class.new(kwargs) }

    before { render_inline(component) }

    specify "renders the call to action" do
      expect(page).to have_css(".call-to-action")
    end

    specify "the icon is present" do
      image_element = page.find("img")
      expect(image_element[:src]).to match(Regexp.new(icon))
    end

    specify "the title is present" do
      expect(page).to have_css(".call-to-action__heading", text: title)
    end

    specify "the text is present" do
      expect(page).to have_css("p", text: text)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end

    context "when no title is present" do
      let(:kwargs) { { icon: icon, text: text, link_text: link_text, link_target: link_target } }

      specify "no paragraph tag should be rendered" do
        expect(page).not_to have_css("h4", class: "call-to-action__heading")
      end
    end

    context "when no text is present" do
      let(:kwargs) { { icon: icon, title: title, link_text: link_text, link_target: link_target } }

      specify "no paragraph tag should be rendered" do
        expect(page).not_to have_css("p", class: "call-to-action__text")
      end
    end

    describe "utility classes" do
      %w[mobile tablet desktop].each do |size|
        context "hiding on #{size}" do
          let(:display_arg_key) { "hide_on_#{size}".to_sym }
          let(:display_args) { { display_arg_key => true } }
          let(:component) { described_class.new(kwargs.merge(display_args)) }

          specify "adds a .hide-on-#{size} class to the call to action" do
            expect(page).to have_css(".call-to-action.hide-on-#{size}")
          end
        end
      end
    end
  end

  describe "failing to render due to missing args" do
    let(:kwargs) { { icon: icon, link_text: link_text, link_target: link_target } }

    specify "raises an argument error when title and text aren't provided" do
      expect { described_class.new(**kwargs) }.to raise_error(ArgumentError, /title or text must be present/)
    end
  end
end
