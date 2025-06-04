require "rails_helper"

RSpec.describe "Canonical URLs", type: :request do
  subject { response.body }

  context "when requesting the root path" do
    before { get root_path }

    it { is_expected.to include(canonical_tag) }
  end

  context "when requesting a nested path" do
    before { get "/life-as-a-teacher/explore-subjects/physics" }

    it { is_expected.to include(canonical_tag("/life-as-a-teacher/explore-subjects/physics")) }
  end

  context "when requesting a path with query parameters" do
    before { get "/train-to-be-a-teacher", params: { some: "param" } }

    it { is_expected.to include(canonical_tag("/train-to-be-a-teacher")) }
  end

  def canonical_tag(path = nil)
    %(<link href="https://getintoteaching.education.gov.uk#{path}" rel="canonical">)
  end
end
