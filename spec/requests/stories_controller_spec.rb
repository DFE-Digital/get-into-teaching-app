require "rails_helper"

describe StoriesController do
  let(:template) { "testing/markdown_test" }

  before do
    allow_any_instance_of(described_class).to \
      receive(:stories_template).and_return template
  end

  context "#show" do
    subject do
      get "/life-as-a-teacher/my-story-into-teaching/known-page"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    context "for unknown page" do
      let(:template) { "testing/unknown" }
      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end

    context "for invalid page page" do
      let(:template) { "../../secrets.txt" }
      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end
  end
end
