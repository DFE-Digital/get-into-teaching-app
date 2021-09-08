require "rails_helper"

describe ApplicationHelper do
  describe "#analytics_body_tag" do
    let(:id) { "1234" }
    let(:gtm_id) { id }
    let(:ga_id) { id }
    let(:adwords_id) { id }
    let(:bam_id) { id }
    let(:lid_id) { id }
    let(:pinterest_id) { id }
    let(:snapchat_id) { id }
    let(:facebook_id) { id }
    let(:twitter_id) { id }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_TAG_MANAGER_ID").and_return gtm_id
      allow(ENV).to receive(:[]).with("GOOGLE_ANALYTICS_ID").and_return ga_id
      allow(ENV).to receive(:[]).with("GOOGLE_AD_WORDS_ID").and_return adwords_id
      allow(ENV).to receive(:[]).with("PINTEREST_ID").and_return pinterest_id
      allow(ENV).to receive(:[]).with("SNAPCHAT_ID").and_return snapchat_id
      allow(ENV).to receive(:[]).with("FACEBOOK_ID").and_return facebook_id
      allow(ENV).to receive(:[]).with("TWITTER_ID").and_return twitter_id
      allow(ENV).to receive(:[]).with("BAM_ID").and_return bam_id
      allow(ENV).to receive(:[]).with("LID_ID").and_return lid_id
    end

    subject { analytics_body_tag { "<h1>TEST</h1>".html_safe } }

    it { is_expected.to have_css "body h1" }

    describe "the stimulus controllers" do
      it { is_expected.to have_css "body[data-controller~=gtm]" }
      it { is_expected.to have_css "body[data-controller~=pinterest]" }
      it { is_expected.to have_css "body[data-controller~=snapchat]" }
      it { is_expected.to have_css "body[data-controller~=facebook]" }
      it { is_expected.to have_css "body[data-controller~=twitter]" }

      context "with additional stimulus controller" do
        subject { analytics_body_tag(data: { controller: "atest" }) { tag.hr } }

        it { is_expected.to have_css "body[data-controller~=gtm]" }
        it { is_expected.to have_css "body[data-controller~=pinterest]" }
        it { is_expected.to have_css "body[data-controller~=snapchat]" }
        it { is_expected.to have_css "body[data-controller~=facebook]" }
        it { is_expected.to have_css "body[data-controller~=twitter]" }
        it { is_expected.to have_css "body[data-controller~=atest]" }
      end
    end

    describe "the service ids" do
      it { is_expected.to have_css "body[data-analytics-gtm-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-ga-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-adwords-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-pinterest-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-snapchat-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-facebook-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-twitter-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-bam-id=1234]" }
      it { is_expected.to have_css "body[data-analytics-lid-id=1234]" }

      context "with blank service ids" do
        let(:id) { "" }

        it { is_expected.to have_css "body[data-analytics-gtm-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-ga-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-adwords-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-pinterest-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-snapchat-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-facebook-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-twitter-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-bam-id=\"\"]" }
        it { is_expected.to have_css "body[data-analytics-lid-id=\"\"]" }
      end

      context "with no service ids" do
        let(:id) { nil }

        it { is_expected.not_to have_css "body[data-analytics-gtm-id]" }
        it { is_expected.not_to have_css "body[data-analytics-ga-id]" }
        it { is_expected.not_to have_css "body[data-analytics-adwords-id]" }
        it { is_expected.not_to have_css "body[data-analytics-pinterest-id]" }
        it { is_expected.not_to have_css "body[data-analytics-snapchat-id]" }
        it { is_expected.not_to have_css "body[data-analytics-facebook-id]" }
        it { is_expected.not_to have_css "body[data-analytics-twitter-id]" }
        it { is_expected.not_to have_css "body[data-analytics-bam-id]" }
        it { is_expected.not_to have_css "body[data-analytics-lid-id]" }
      end
    end

    describe "the default events" do
      it { is_expected.to have_css "body[data-snapchat-action=track]" }
      it { is_expected.to have_css "body[data-snapchat-event=PAGE_VIEW]" }
      it { is_expected.to have_css "body[data-facebook-action=track]" }
      it { is_expected.to have_css "body[data-facebook-event=PageView]" }
      it { is_expected.to have_css "body[data-twitter-action=track]" }
      it { is_expected.to have_css "body[data-twitter-event=PageView]" }
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

  describe "#internal_referer" do
    before { helper.request = double("request") }

    it "returns nil if the referrer is not set" do
      allow(helper.request).to receive(:referer).and_return nil
      expect(helper.internal_referer).to be_nil
    end

    it "returns nil if the referrer is empty" do
      allow(helper.request).to receive(:referer).and_return " "
      expect(helper.internal_referer).to be_nil
    end

    it "returns nil if the referrer is external" do
      allow(helper.request).to receive(:referer).and_return "https://external.com"
      expect(helper.internal_referer).to be_nil
    end

    it "returns the referrer if internal" do
      allow(helper.request).to receive(:referer).and_return root_url
      expect(helper.internal_referer).to eql(helper.root_path)
    end
  end

  describe "#fa_icon" do
    let(:icon_name) { "myspace" }

    subject { helper.fa_icon(icon_name) }

    it "returns an empty span with the default classes" do
      expect(subject).to have_css("span.fas.fa-#{icon_name}")
    end

    context "with FA styles" do
      let(:style) { "fad" }

      subject { helper.fa_icon(icon_name, style: style) }

      it "returns an empty span with provided style class" do
        expect(subject).to have_css("span.#{style}.fa-#{icon_name}")
      end
    end

    context "with extra classes" do
      let(:extra_classes) { %w[abc def] }

      subject { helper.fa_icon(icon_name, *extra_classes) }

      it "returns an empty span with the extra classes" do
        expect(subject).to have_css(%(span.fa-#{icon_name}.#{extra_classes.join('.')}))
      end
    end
  end

  describe "#fab_icon" do
    let(:icon_name) { "friendster" }

    subject { helper.fab_icon(icon_name) }

    after { subject }

    it %(it returns a span with class 'fab') do
      expect(helper).to receive(:fa_icon).once.with(icon_name, style: "fab")
    end
  end

  describe "#fas_icon" do
    let(:icon_name) { "orkut" }

    subject { helper.fas_icon(icon_name) }

    after { subject }

    it %(it returns a span with class 'fas') do
      expect(helper).to receive(:fa_icon).once.with(icon_name, style: "fas")
    end
  end

  describe "#replace_bau_cookies_link" do
    subject { helper.replace_bau_cookies_link html }

    context "when in href" do
      let :html do
        <<~HTML
          <p>
            <a href="/first">First</a>
          </p>

          </p>
            <a href="https://getintoteaching.education.gov.uk/how-we-use-your-information">
              Information
            </a>
          </p>
        HTML
      end

      it { is_expected.to have_link "First", href: "/first" }
      it { is_expected.to have_link "Information", href: cookies_path }
    end
  end

  describe "#chat_link" do
    let(:text) { "Chat with us" }
    let(:extra_class) { "button" }

    subject { helper.chat_link(text, classes: extra_class) }

    it %(generates a hyperlink) do
      expect(subject).to have_css("a")
    end

    it %(has the right data controller) do
      expect(subject).to have_css(%(a[data-controller="talk-to-us"]))
    end

    it %(has the right data action) do
      expect(subject).to have_css(%(a[data-action="talk-to-us#startChat"]))
    end

    it %(applies the correct class) do
      expect(subject).to have_css(%(a.button))
    end
  end
end
