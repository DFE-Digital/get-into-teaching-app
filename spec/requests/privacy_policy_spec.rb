require "rails_helper"

describe "GET /privacy-policy", type: :request do
  let(:policy) { GetIntoTeachingApiClient::PrivacyPolicy.new(id: "123", text: "Latest privacy policy") }

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
  end

  context "when viewing a privacy policy by id" do
    subject do
      get(privacy_policy_path(id: policy.id))
      response
    end

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
        receive(:get_privacy_policy).with(policy.id).and_return(policy)
    end

    it { is_expected.to have_http_status :success }
    it { expect(subject.body).to include(policy.text) }
  end
end
