require "rails_helper"

describe ApplicationHelper do
  describe "#analytics_body_tag" do
    subject { analytics_body_tag { "<h1>TEST</h1>".html_safe } }

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
      allow(Rails.application.config.x).to receive(:legacy_tracking_pixels).and_return(true)
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

    context "when legacy tracking is disabled" do
      subject { analytics_body_tag(data: { timefmt: "24", controller: "something" }, class: "homepage") { tag.hr } }

      before { allow(Rails.application.config.x).to receive(:legacy_tracking_pixels).and_return(false) }

      it { is_expected.not_to have_css "body[data-controller=gtm]" }
      it { is_expected.to have_css "body[data-controller='something gtm-consent']" }
      it { is_expected.to have_css "body[data-timefmt=24]" }
      it { is_expected.to have_css "body.homepage" }
      it { is_expected.to have_css "body hr" }
    end
  end

  describe "#internal_referer" do
    before { helper.request = instance_double("ActionDispatch::Request") }

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
    subject { helper.fa_icon(icon_name) }

    let(:icon_name) { "myspace" }

    it "returns an empty span with the default classes" do
      expect(subject).to have_css("span.fas.fa-#{icon_name}")
    end

    context "with FA styles" do
      subject { helper.fa_icon(icon_name, style: style) }

      let(:style) { "fad" }

      it "returns an empty span with provided style class" do
        expect(subject).to have_css("span.#{style}.fa-#{icon_name}")
      end
    end

    context "with extra classes" do
      subject { helper.fa_icon(icon_name, *extra_classes) }

      let(:extra_classes) { %w[abc def] }

      it "returns an empty span with the extra classes" do
        expect(subject).to have_css(%(span.fa-#{icon_name}.#{extra_classes.join('.')}))
      end
    end
  end

  describe "#fab_icon" do
    subject { helper.fab_icon(icon_name) }

    let(:icon_name) { "friendster" }

    after { subject }

    it "returns a span with class 'fab'" do
      expect(helper).to receive(:fa_icon).once.with(icon_name, style: "fab")
    end
  end

  describe "#fas_icon" do
    subject { helper.fas_icon(icon_name) }

    let(:icon_name) { "orkut" }

    after { subject }

    it "returns a span with class 'fas'" do
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

  describe "#privacy_page?" do
    subject { helper.privacy_page?(path) }

    ["/cookie_preference", "/cookies", "/privacy-policy"].each do |privacy_path|
      context "when #{privacy_path}" do
        let(:path) { privacy_path }

        it { is_expected.to be(true) }
      end
    end

    context "when not a privacy path" do
      let(:path) { "/a-page" }

      it { is_expected.to be(false) }
    end
  end

  describe "#google_optimize_script" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_OPTIMIZE_ID") { id }
      described_class.class_variable_set(:@@google_optimize_config, { paths: paths })
    end

    after do
      described_class.class_variable_set(:@@google_optimize_config, nil)
    end

    subject { google_optimize_script }

    context "when the GOOGLE_OPTIMIZE_ID is not set" do
      let(:id) { nil }

      context "when there are experiment paths" do
        let(:paths) { ["/experiment"] }

        it { is_expected.to be_nil }
      end

      context "when there are no experiment paths" do
        let(:paths) { [] }

        it { is_expected.to be_nil }
      end
    end

    context "when the GOOGLE_OPTIMIZE_ID is set" do
      let(:id) { "ABC-123" }

      context "when there are experiment paths" do
        let(:paths) { ["/experiment"] }

        it "renders the Google Optimize script" do
          regex = %r{
            <script\s
            src="/packs-test/v1/js/google_optimize.*\.js"\s
            data-turbolinks-track="reload"\s
            data-google-optimize-id="ABC-123"\s
            data-google-optimize-paths="\[&quot;/experiment&quot;\]"
            ></script>
          }x

          is_expected.to match(regex)
        end
      end

      context "when there are no experiment paths" do
        let(:paths) { [] }

        it { is_expected.to be_nil }
      end
    end
  end

  describe "#google_optimize_config" do
    subject { google_optimize_config }

    it { is_expected.to eq({ paths: ["/test/a", "/test/b"] }) }
  end
end
