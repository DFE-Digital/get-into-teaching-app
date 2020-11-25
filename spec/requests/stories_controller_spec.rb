require "rails_helper"

shared_examples "page cannot be found" do |template|
  context "for unknown page" do
    let(:template) { template }
    it { is_expected.to have_http_status :not_found }
    it { is_expected.to have_attributes body: %r{Page not found} }
  end

  context "for invalid page page" do
    let(:template) { "../../secrets.txt" }
    it { is_expected.to have_http_status :not_found }
    it { is_expected.to have_attributes body: %r{Page not found} }
  end
end

describe StoriesController do
  let(:template) { "testing/markdown_test" }
  let(:page) { double Pages::Page, template: template }

  before { allow(Pages::Page).to receive(:find).and_return page }

  context "#landing" do
    subject do
      get "/my-story-into-teaching/"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    include_examples "page cannot be found", "testing/unknown"
  end

  context "#index" do
    subject do
      get "/my-story-into-teaching/returners"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    include_examples "page cannot be found", "testing/unknown"
  end

  context "#show" do
    subject do
      get "/my-story-into-teaching/returners/known-page"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    include_examples "page cannot be found", "testing/unknown"
  end
end
