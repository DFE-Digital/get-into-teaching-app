require "rails_helper"

describe TextFormattingHelper, type: :helper do
  describe "#safe_format" do
    subject { safe_format(content) }

    context "with new lines" do
      let(:content) { "hello\r\n\r\nworld" }

      it "wraps content as paragraph" do
        expect(subject).to eq("<p>hello</p>\n\n<p>world</p>")
      end
    end

    context "with html content" do
      let(:content) { "<strong>hello</strong> <em>world</em>" }

      it "removes tags and wraps content as paragraph" do
        expect(subject).to eq("<p>hello world</p>")
      end
    end

    context "with a custom wrapper tag" do
      subject { safe_format(content, wrapper_tag: tag) }

      let(:content) { "hello\r\n\r\nworld" }
      let(:tag) { "span" }

      it "wraps content in tag" do
        expect(subject).to eq("<span>hello</span>\n\n<span>world</span>")
      end
    end
  end

  describe "#safe_html_format" do
    subject { safe_html_format html }

    context "with allowed HTML" do
      let(:html) do
        <<~HTML
          <div>test</div>
          <p id="paragraph">
            <strong>hello</strong>
            <a href="http://test.com">world</a>
          </p>
          <ul>
            <li>test</li>
          </ul>
          <span class="test">test</span>
          <h1>heading1</h1>
          <h2>heading1</h2>
          <h3>heading1</h3>
          <h4>heading1</h4>
          <h5>heading1</h5>
          <br>
          <link href="/test" rel="canonical">
        HTML
      end

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

    context "with href containing disallowed protocol" do
      let(:html) { "<a href=\"file://test.com\" target=\"blank\">open</a>" }

      it { is_expected.to eql "<a target=\"blank\">open</a>" }
    end
  end
end
