require "rails_helper"

RSpec.describe Pages::Navigation do
  let(:primary_nav) do
    {
      "/page-one" => { title: "Page one", navigation: 1 },
      "/page-two" => { title: "Page two", navigation: 2 },
      "/page-three" => { title: "Page three", navigation: 3 },
      "/page-four" => { title: "Page four", navigation: 4 },
      "/page-five" => { title: "Page five", navigation: 5, menu: true },
      "/page-six" => { title: "Page six", navigation: 6, menu: true },
      "/page-seven" => { title: "Page seven", navigation: 7 },
    }
  end

  let(:secondary_nav) do
    {
      "/page-five/part-1" => { title: "Page five: part 1", navigation: 5.1 },
      "/page-five/part-2" => { title: "Page five: part 2", navigation: 5.2 },
      "/page-five/part-3" => { title: "Page five: part 3", navigation: 5.3 },
      "/page-six/part-1" => { title: "Page six: part 1", navigation: 6.1 },
      "/page-six/part-2" => { title: "Page six: part 2", navigation: 6.2 },
      "/page-six/part-3" => { title: "Page six: part 3", navigation: 6.3 },
    }
  end

  let(:nav) { primary_nav.merge(secondary_nav) }
  let(:actual_pages) { subject.map(&:path) }

  describe "delegation" do
    subject { described_class }

    it { is_expected.to delegate_method(:all_pages).to(:instance) }
    it { is_expected.to delegate_method(:root_pages).to(:instance) }
  end

  describe "#all_pages" do
    subject { described_class.new(nav).all_pages }

    specify "contains all of the pages, both primary and secondary" do
      expected_pages = nav.keys

      expect(actual_pages).to match_array(expected_pages)
    end

    specify "pages are in the right order" do
      expected_order = nav.sort_by { |_p, fm| fm[:navigation] }.map { |path, _fm| path }

      expect(actual_pages).to eql(expected_order)
    end
  end

  describe "#root_pages" do
    subject { described_class.new(nav).root_pages }
    let(:actual_pages) { subject.map(&:path) }

    specify "contains only the root pages" do
      expected_pages = primary_nav.keys

      expect(actual_pages).to match_array(expected_pages)
    end
  end

  describe Pages::Navigation::Node do
    let(:path) { "/an-amazing-page" }
    let(:title) { "Page five" }
    let(:navigation) { 5 }
    let(:menu) { true }
    let(:front_matter) { { title: title, navigation: navigation, menu: menu } }

    subject { described_class.new(path, front_matter) }

    specify "assigns the path" do
      expect(subject.path).to eql(path)
    end

    specify "assigns the title" do
      expect(subject.title).to eql(title)
    end

    specify "assigns the navigation param to rank" do
      expect(subject.rank).to eql(navigation)
    end

    specify "assigns the menu flag" do
      expect(subject.menu?).to eql(menu)
    end

    context "when front matter is incomplete" do
      let(:front_matter) { {} }

      before do
        allow(Rails.logger).to receive(:warn) { true }
      end

      specify "title is nil and warning logged" do
        expect(subject.title).to be(nil)

        expect(Rails.logger).to have_received(:warn).with(/has no title/)
      end

      specify "rank is nil" do
        expect(subject.rank).to be_nil
      end

      specify "menu is false" do
        expect(subject.menu?).to be(false)
      end
    end

    describe "#root?" do
      examples = {
        "/" => true,
        "/path" => true,
        "/path-with-trailing-slash/" => true,
        "/path/with-subpage" => false,
        "/path/with-multiple/subpages" => false,
      }

      examples.each do |path, expected|
        specify "path '#{path}' should #{expected ? '' : 'not '}be root" do
          node = described_class.new(path, {})

          expect(node.root?).to eql(expected)
        end
      end
    end
  end
end
