require "rails_helper"

RSpec.describe Pages::Blog do
  let(:pages) do
    {
      # 5*january 4*february, 3*march, 2*april, 1*may
      a: { date: "2019-01-01", tags: %w[january february march april may] },
      b: { date: "2019-01-01", tags: %w[january february march april] },
      c: { date: "2019-01-01", tags: %w[january february march] },
      d: { date: "2019-01-01", tags: %w[january february] },
      e: { date: "2019-01-01", tags: %w[january] },

      # 4*june, 3*july, 2*august, 1*september
      f: { date: "2019-01-01", tags: %w[june july august september] },
      g: { date: "2019-01-01", tags: %w[june july august] },
      h: { date: "2019-01-01", tags: %w[june july] },
      i: { date: "2019-01-01", tags: %w[june] },
    }
  end

  describe ".find" do
    before { allow(Pages::Page).to receive(:find).with("/some/template").and_return("/some_template.md") }
    subject { described_class }

    specify "calls the other method" do
      described_class.find("/some/template")

      expect(Pages::Page).to have_received(:find).with("/some/template").once
    end
  end

  describe "#posts" do
    describe "retrieves pages in blog directory by default" do
      subject { described_class.new }

      specify "there is at least one blog post" do
        expect(subject.posts.size).to be >= 1
      end

      specify "all posts are in the blog directory" do
        expect(subject.posts.keys).to all(start_with("/blog"))
      end
    end

    context "when filtering by a single tag" do
      let(:wanted_tag) { "august" }
      subject { described_class.new(pages) }

      specify "return the right number of posts" do
        expect(subject.posts(wanted_tag).size).to be 2
      end

      specify "all returned posts have the right tag" do
        tags_per_post = subject.posts(wanted_tag).map { |_p, fm| fm[:tags] }

        expect(tags_per_post).to all(include(wanted_tag))
      end
    end
  end

  describe "#popular_tags" do
    subject { described_class.new(pages).popular_tags }

    specify "orders by frequency then alphabetically" do
      expect(subject).to eql(%w[january february june july march])
    end

    context "with a custom limit" do
      subject { described_class.new(pages).popular_tags(7) }

      specify "orders by frequency then alphabetically" do
        expect(subject).to eql(%w[january february june july march april august])
      end
    end
  end

  describe "#similar_posts" do
    let(:origin_tags) { %w[june july] }
    let(:origin_path) { :f }
    let(:origin_fm) { OpenStruct.new(tags: origin_tags) }
    let(:origin) { OpenStruct.new(path: origin_path, frontmatter: origin_fm) }

    subject { described_class.new(pages).similar_posts(origin) }

    specify "returns pages that have overlapping tags" do
      tags = subject.values.map { |fm| fm[:tags] }

      tags.each do |tags_per_similar_post|
        expect((tags_per_similar_post & origin_tags).size).to be > 0
      end
    end

    specify "orders by the number of overlapping tags" do
      # :i has one overlap (june), :g and :h are have two
      expect(subject.keys.last).to be(:i)
    end

    specify "does not include the original post" do
      expect(subject.keys).not_to include(origin_path)
    end

    context "when a limit is applied" do
      let(:limit) { 2 }
      subject { described_class.new(pages).similar_posts(origin, limit) }

      specify "only the right number of posts are returned" do
        expect(subject.size).to be(limit)
      end
    end
  end
end
