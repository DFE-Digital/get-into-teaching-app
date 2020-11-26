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

  context "#landing" do
    before do
      allow_any_instance_of(described_class).to \
        receive(:landing_template).and_return template
    end

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
    before do
      allow_any_instance_of(described_class).to \
        receive(:index_template).and_return template
    end

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
    before do
      allow_any_instance_of(described_class).to \
        receive(:stories_template).and_return template
    end

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
