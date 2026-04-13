require "rails_helper"

describe "Redirecting home page to old/new branded page for split testing", type: :request do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("SPLIT_TEST", nil).and_return(split_test)
    allow_any_instance_of(PagesController).to receive(:branding).and_return(branding)
  end

  context "when split testing is not enabled" do
    let(:split_test) { "FALSE" }
    let(:branding) { "current" }

    it "does not redirect the homepage" do
      get "/"
      expect(response).not_to redirect_to(action: "home")
      expect(response.status).to be(200)
    end
  end

  context "when split testing is enabled" do
    let(:split_test) { "TRUE" }

    context("when rebrand is chosen") do
      let(:branding) { "rebrand" }

      it "redirects to the rebranded homepage" do
        get "/"
        expect(response).to redirect_to(action: "home", params: { branding: branding })
      end

      it "does not redirect if a branding is already specified" do
        get "/?branding=current"
        expect(response).not_to redirect_to(action: "home", params: { branding: branding })
        expect(response.status).to be(200)
      end
    end

    context("when current is chosen") do
      let(:branding) { "current" }

      it "redirects to the current homepage" do
        get "/"
        expect(response).to redirect_to(action: "home", params: { branding: branding })
      end

      it "does not redirect if a branding is already specified" do
        get "/?branding=rebrand"
        expect(response).not_to redirect_to(action: "home", params: { branding: branding })
        expect(response.status).to be(200)
      end
    end
  end
end
