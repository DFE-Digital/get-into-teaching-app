require "rails_helper"

describe TextFormattingHelper, type: :helper do
  describe "#safe_format" do
    subject { safe_format content }

    context "with new lines" do
      let(:content) { "hello\r\n\r\nworld" }
      it { is_expected.to eql "<p>hello</p>\n\n<p>world</p>" }
    end

    context "with html content" do
      let(:content) { "<strong>hello</strong> <em>world</em>" }
      it { is_expected.to eql "<p>hello world</p>" }
    end
  end

  describe "#safe_html_format" do
    subject { safe_html_format html }

    context "with allowed HTML" do
      let(:html) { "<div>test</div><p><strong>hello</strong> <a href=\"http://test.com\">world</a></p><ul><li>test</li></ul><span>test</span>" }
      it { is_expected.to eql html }
    end

    context "with disallowed HTML" do
      let(:html) { "<script>malicious</script>" }
      it { is_expected.to eql "malicious" }
    end

    context "with malicious anchor tags" do
      let(:html) { "<a href=\"http://test.com\" onclick=\"somethingNasty();\">boom</a>" }
      it { is_expected.to eql "<a href=\"http://test.com\">boom</a>" }
    end

    context "with anchor tags" do
      let(:html) { "<a href=\"http://test.com\" target=\"blank\">open</a>" }
      it { is_expected.to eql html }
    end
  end
end
