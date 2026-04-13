require "rails_helper"

describe "Redirecting home page to old/new branded page for split testing", type: :request do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("SPLIT_TEST", nil).and_return(split_test)
    allow_any_instance_of(PagesController).to receive(:branding).and_return(branding)
  end

  context "when split testing is not enabled" do
    let(:split_test) { "FALSE" }
    let(:branding) { "old_brand" }

    it "does not redirect the homepage" do
      get "/"
      expect(response).not_to redirect_to(action: "home")
      expect(response.status).to be(200)
    end
  end

  context "when split testing is enabled" do
    let(:split_test) { "TRUE" }

    context("when new_brand is chosen") do
      let(:branding) { "new_brand" }

      it "redirects to the new_brand homepage" do
        get "/"
        expect(response).to redirect_to(action: "home", params: { field_test: { branding: branding } })
      end

      it "does not redirect if a branding is already specified" do
        get "/?field_test%5Bbranding%5D=old_brand"
        expect(response).not_to redirect_to(action: "home", params: { field_test: { branding: branding } })
        expect(response.status).to be(200)
      end
    end

    context("when old_brand is chosen") do
      let(:branding) { "old_brand" }

      it "redirects to the old_brand homepage" do
        get "/"
        expect(response).to redirect_to(action: "home", params: { field_test: { branding: branding } })
      end

      it "does not redirect if a branding is already specified" do
        get "/?field_test%5Bbranding%5D=new_brand"
        expect(response).not_to redirect_to(action: "home", params: { field_test: { branding: branding } })
        expect(response.status).to be(200)
      end
    end
  end
end
