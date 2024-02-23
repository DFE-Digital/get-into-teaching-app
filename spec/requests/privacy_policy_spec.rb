require "rails_helper"

describe "GET /privacy-policy", type: :request do
  let(:policy) { GetIntoTeachingApiClient::PrivacyPolicy.new(id: "efffa2d3-381b-4a33-baa5-d6806a9c3d57", text: "Latest privacy policy") }

  context "when viewing the latest privacy policy" do
    subject do
      get(privacy_policy_path)
      response
    end

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
        receive(:get_latest_privacy_policy).with(no_args).and_return(policy)
    end

    it { is_expected.to have_http_status :success }
    it { expect(subject.body).to include(policy.text) }
    it { expect(subject.body).not_to include("Live chat") }
  end

  context "when viewing a privacy policy with an id" do
    subject do
      get(privacy_policy_path(id: id))
      response
    end

    context "when the id is valid" do
      let(:id) { policy.id }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
          receive(:get_privacy_policy).with(id).and_return(policy)
      end

      it { is_expected.to have_http_status :success }
      it { expect(subject.body).to include(policy.text) }
    end

    context "when the id cannot be found in the CRM" do
      let(:id) { "c3ef3edb-6566-4f6a-bd9c-09740f13a05f" }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
          receive(:get_privacy_policy).with(id).and_raise(GetIntoTeachingApiClient::ApiError.new(code: 404, message: "Not Found"))
      end

      it { is_expected.to have_http_status :missing }
      it { expect(subject.body).to include("Page not found") }
    end

    context "when the id is not valid" do
      let(:id) { "invalid+id%?/|[]{}=true;" }

      it { is_expected.to have_http_status :bad_request }
      it { expect(subject.body).to include("Bad request") }
    end
  end
end
