require "rails_helper"

describe BlogHelper, type: "helper" do
  describe "#format_blog_date" do
    let(:markdown_date) { "2019-03-04" }

    subject { format_blog_date(markdown_date) }

    specify "formats the date in the GOV.UK short style" do
      expect(subject).to eql("4 March 2019")
    end
  end
end
