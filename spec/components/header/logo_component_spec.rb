require "rails_helper"

describe Header::LogoComponent, type: "component" do
  subject! { render_inline(component) }

  let(:component) { described_class.new }

  specify "renders the logo wrapper with the get into teaching and DfE logos" do
    expect(page).to have_css(".logo-wrapper") do |wrapper|
      expect(wrapper).to have_css(".logo")
    end
  end
end
