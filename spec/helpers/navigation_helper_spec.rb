require "rails_helper"

describe NavigationHelper, type: :helper do
  describe "#navigation_resources" do
    before do
      allow(Pages::Navigation).to receive(:root_pages)
      helper.navigation_resources
    end

    specify "calls Pages::Navigation.root_pages" do
      expect(Pages::Navigation).to have_received(:root_pages).with(no_args)
    end
  end
end
