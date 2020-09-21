require "rails_helper"

describe ApplicationHelper do
  describe "#analytics_body_tag" do
    let(:id) { "1234" }
    let(:gtm_id) { id }
    let(:bam_id) { id }
    let(:pinterest_id) { id }
    let(:snapchat_id) { id }
    let(:facebook_id) { id }
    let(:twitter_id) { id }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_TAG_MANAGER_ID").and_return gtm_id
      allow(ENV).to receive(:[]).with("PINTEREST_ID").and_return pinterest_id
      allow(ENV).to receive(:[]).with("SNAPCHAT_ID").and_return snapchat_id
      allow(ENV).to receive(:[]).with("FACEBOOK_ID").and_return facebook_id
      allow(ENV).to receive(:[]).with("TWITTER_ID").and_return twitter_id
      allow(ENV).to receive(:[]).with("BAM_ID").and_return bam_id
    end

    subject { analytics_body_tag { "<h1>TEST</h1>".html_safe } }

    it { is_expected.to have_css "body h1" }

    context "includes stimulus controllers" do
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
      it { is_expected.to have_css "body[data-controller~=twitter]" }
    end

    context "assigns service ids" do
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-twitter-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-bam-id=1234]" }
    end

    context "with blank service ids" do
      let(:id) { "" }
      it { is_expected.to have_css "body[data-analytics-gtm-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-twitter-id=\"\"]" }
      it { is_expected.to have_css "body[data-analytics-bam-id=\"\"]" }
    end

    context "with no service ids" do
      let(:id) { nil }
      it { is_expected.not_to have_css "body[data-analytics-gtm-id]" }
      it { is_expected.not_to have_css "body[data-analytics-pinterest-id]" }
      it { is_expected.not_to have_css "body[data-analytics-snapchat-id]" }
      it { is_expected.not_to have_css "body[data-analytics-facebook-id]" }
      it { is_expected.not_to have_css "body[data-analytics-twitter-id]" }
      it { is_expected.not_to have_css "body[data-analytics-bam-id]" }
    end

    context "default events" do
      it { is_expected.to have_css "body[data-snapchat-action=track]" }
      it { is_expected.to have_css "body[data-snapchat-event=PAGE_VIEW]" }
      it { is_expected.to have_css "body[data-facebook-action=track]" }
      it { is_expected.to have_css "body[data-facebook-event=PageView]" }
      it { is_expected.to have_css "body[data-twitter-action=track]" }
      it { is_expected.to have_css "body[data-twitter-event=PageView]" }
    end

    context "with additional stimulus controller" do
      subject { analytics_body_tag(data: { controller: "atest" }) { tag.hr } }
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
      it { is_expected.to have_css "body[data-controller~=twitter]" }
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
