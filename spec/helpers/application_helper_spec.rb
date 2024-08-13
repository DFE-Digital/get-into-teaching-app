require "rails_helper"

describe ApplicationHelper do
  describe "#body_tag" do
    before { allow(ENV).to receive(:[]).with("APP_ASSETS_URL").and_return("asset-url") }

    subject { body_tag(data: { timefmt: "24", controller: "something" }, class: "homepage") { tag.hr } }

    it { is_expected.to have_css "body[data-controller='something link table']" }
    it { is_expected.to have_css "body[data-timefmt=24]" }
    it { is_expected.to have_css "body[data-link-target=content]" }
    it { is_expected.to have_css "body[data-link-asset-url-value=asset-url]" }
    it { is_expected.to have_css "body.homepage.govuk-template__body.govuk-body" }
    it { is_expected.to have_css "body#body" }
    it { is_expected.to have_css "body hr" }
  end

  describe "#main_tag" do
    subject { main_tag(class: "homepage") { tag.hr } }

    it { is_expected.to have_css "main[id=main-content]" }
    it { is_expected.to have_css "main.homepage" }
    it { is_expected.to have_css "body hr" }
  end

  describe "#suffix_title" do
    subject { suffix_title(title) }

    context "when no title is provided" do
      let(:title) { nil }

      it { is_expected.to eq("Get Into Teaching GOV.UK") }
    end

    context "when a title is provided" do
      let(:title) { "My Title" }

      it { is_expected.to eq("My Title | Get Into Teaching GOV.UK") }
    end
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
    before { helper.request = instance_double(ActionDispatch::Request) }

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

    it "hides the icon from screen readers" do
      expect(subject).to have_css("span[aria-hidden=true]")
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

  describe "#human_boolean" do
    it { expect(human_boolean(true)).to eq("Yes") }
    it { expect(human_boolean(false)).to eq("No") }
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

  describe "#content_footer_kwargs" do
    let(:front_matter) { {} }

    subject { content_footer_kwargs(front_matter) }

    it { is_expected.to eq({ talk_to_us: true }) }

    context "when overriden in the front_matter" do
      let(:front_matter) { { talk_to_us: false, other: false } }

      it { is_expected.to eq({ talk_to_us: false }) }
    end
  end
end
