require "spec_helper"
require "accessible_footnotes"

describe AccessibleFootnotes do
  describe "#html" do
    subject(:render_html) { instance.process.to_html }

    let(:body) do
      <<~HTML
        <a href="#fn:2" class="footnote">2</a>
        <a href="#fnref:2" class="reversefootnote">↩</a>
      HTML
    end
    let(:instance) { described_class.new(Nokogiri::HTML(body)) }

    it { is_expected.to include(%(<a href="#fn:2" class="footnote"><span class="visually-hidden">Footnote </span>2</a>)) }
    it { is_expected.to include(%(<a href="#fnref:2" class="reversefootnote"><span class="visually-hidden">Location of footnote 2</span>↩</a>)) }
  end
end
