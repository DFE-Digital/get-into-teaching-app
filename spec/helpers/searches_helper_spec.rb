require "rails_helper"

RSpec.describe SearchesHelper do
  describe "#humanize_path" do
    subject { humanize_path path }

    let(:path) { "/foo/foo-bar/baz" }

    it { is_expected.to be_html_safe }
    it { is_expected.to eql "<span>Foo &rsaquo;</span> <span>Foo bar &rsaquo;</span>" }

    context "with custom separator" do
      subject { humanize_path(path, separator: ".", &:upcase) }

      it { is_expected.to be_html_safe }
      it { is_expected.to eql "FOO.FOO-BAR" }
    end
  end

  describe "humanize_path_segment" do
    subject { humanize_path_segment "foo-bar" }

    it { is_expected.to be_html_safe }
    it { is_expected.to eql "<span>Foo bar &rsaquo;</span>" }
  end
end
