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
  include_context "always render testing page"

  describe "#landing" do
    subject do
      get "/my-story-into-teaching/"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    include_examples "page cannot be found", "testing/unknown"
  end

  describe "#index" do
    subject do
      get "/my-story-into-teaching/returners"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    include_examples "page cannot be found", "testing/unknown"
  end

  describe "#show" do
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
