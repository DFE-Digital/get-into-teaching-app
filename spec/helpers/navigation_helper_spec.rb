require "rails_helper"

describe NavigationHelperSpec, type: :helper do
  describe "#navigation_resources" do
    before { allow(Pages::Navigation).to receive(:root_pages) }

    subject! { helper.navigation_resources }

    specify "calls Pages::Navigation.root_pages" do
      expect(Pages::Navigation).to have_received(:root_pages).with(no_args)
    end
  end
end
