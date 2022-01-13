require "rails_helper"

describe ApplicationHelper do
  describe "#analytics_body_tag" do
    subject { analytics_body_tag(data: { timefmt: "24", controller: "something" }, class: "homepage") { tag.hr } }

    it { is_expected.not_to have_css "body[data-controller=gtm]" }
    it { is_expected.to have_css "body[data-controller='something gtm-consent']" }
    it { is_expected.to have_css "body[data-timefmt=24]" }
    it { is_expected.to have_css "body.homepage" }
    it { is_expected.to have_css "body hr" }
  end

  describe "#new_gtm_enabled?" do
    it "returns true when GTM_ID is present" do
      allow(ENV).to receive(:[]).with("GTM_ID").and_return("ABC-123")
      expect(helper).to be_gtm_enabled
    end

    it "returns false when GTM_ID is blank" do
      allow(ENV).to receive(:[]).with("GTM_ID").and_return("")
      expect(helper).not_to be_gtm_enabled

      allow(ENV).to receive(:[]).with("GTM_ID").and_return(nil)
      expect(helper).not_to be_gtm_enabled
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

    it { is_expected.to eq({ paths: ["/test/a", "/test/b", "/events", "/teaching-events"] }) }
  end

  describe "#sentry_dsn" do
    subject { sentry_dsn }

    it { is_expected.to be_nil }

    context "when sentry dsn exist" do
      before { allow(Sentry.configuration).to receive(:dsn).and_return("1234") }

      it { is_expected.to eq("1234") }

      context "when in production" do
        before { allow(Rails).to receive(:env) { "production".inquiry } }

        it { is_expected.to be_nil }
      end
    end
  end
end
