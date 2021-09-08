require "rails_helper"

describe Header::LogoComponent, type: "component" do
  let(:component) { described_class.new }

  subject! { render_inline(component) }

  specify "renders the logo wrapper with the get into teaching and DfE logos" do
    expect(page).to have_css(".logo-wrapper") do |wrapper|
      expect(wrapper).to have_css(".logo")
    end
  end
end
