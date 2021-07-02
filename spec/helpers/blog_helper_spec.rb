require "rails_helper"

describe BlogHelper, type: "helper" do
  describe "#format_blog_date" do
    let(:markdown_date) { "2019-03-04" }

    subject { format_blog_date(markdown_date) }

    specify "formats the date in the GOV.UK short style" do
      expect(subject).to eql("4 March 2019")
    end
  end

  describe "#most_popular_tags" do
    let(:pages) do
      {
        # 5*january 4*february, 3*march, 2*april, 1*may
        a: { tags: %w[january february march april may] },
        b: { tags: %w[january february march april] },
        c: { tags: %w[january february march] },
        d: { tags: %w[january february] },
        e: { tags: %w[january] },

        # 4*june, 3*july, 2*august, 1*september
        f: { tags: %w[june july august september] },
        g: { tags: %w[june july august] },
        h: { tags: %w[june july] },
        i: { tags: %w[june] },
      }
    end

    before { allow(Pages::Frontmatter).to receive(:select_by_path).with("/blog").and_return(pages) }

    subject { most_popular_tags }

    specify "orders by frequency then alphabetically" do
      expect(subject).to eql(%w[january february june july march])
    end

    context "with a custom limit" do
      subject { most_popular_tags(7) }

      specify "orders by frequency then alphabetically" do
        expect(subject).to eql(%w[january february june july march april august])
      end
    end
  end
end
