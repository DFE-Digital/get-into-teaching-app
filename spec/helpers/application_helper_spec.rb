require "rails_helper"

describe ApplicationHelper do
  describe "#analytics_body_tag" do
    let(:gtm_id) { "1234" }
    let(:pinterest_id) { gtm_id }
    let(:snapchat_id) { gtm_id }
    let(:facebook_id) { gtm_id }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_TAG_MANAGER_ID").and_return gtm_id
      allow(ENV).to receive(:[]).with("PINTEREST_ID").and_return pinterest_id
      allow(ENV).to receive(:[]).with("SNAPCHAT_ID").and_return snapchat_id
      allow(ENV).to receive(:[]).with("FACEBOOK_ID").and_return facebook_id
    end

    subject { analytics_body_tag { "<h1>TEST</h1>".html_safe } }

    it { is_expected.to have_css "body h1" }

    context "includes stimulus controllers" do
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
    end

    context "assigns service ids" do
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=1234]" }
    end

    context "with blank service ids" do
      let(:gtm_id) { "" }
      it { is_expected.to have_css "body[data-analytics-gtm-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=\"\"]" }
    end

    context "with no service ids" do
      let(:gtm_id) { nil }
      it { is_expected.not_to have_css "body[data-analytics-gtm-id]" }
      it { is_expected.not_to have_css "body[data-analytics-pinterest-id]" }
      it { is_expected.not_to have_css "body[data-analytics-snapchat-id]" }
      it { is_expected.not_to have_css "body[data-analytics-facebook-id]" }
    end

    context "default events" do
      it { is_expected.to have_css "body[data-snapchat-action=track]" }
      it { is_expected.to have_css "body[data-snapchat-event=PAGE_VIEW]" }
      it { is_expected.to have_css "body[data-facebook-action=track]" }
      it { is_expected.to have_css "body[data-facebook-event=PageView]" }
    end

    context "with additional stimulus controller" do
      subject { analytics_body_tag(data: { controller: "atest" }) { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
      it { is_expected.to have_css "body[data-controller~=atest]" }
    end

    context "with other data attributes" do
      subject { analytics_body_tag(data: { timefmt: "24" }) { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-timefmt=24]" }
    end

    context "with other attributes" do
      subject { analytics_body_tag(class: "homepage") { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body.homepage" }
    end
  end
end
