require "rails_helper"

describe CategoriesHelper, type: :helper do
  let(:sample_path) { "/train-to-be-a-teacher" }

  describe "#ungrouped_categories" do
    subject { ungrouped_categories(sample_path) }

    specify "returns only pages with no subcategory" do
      expect(subject.map(&:subcategory)).to all(be_nil)
    end
  end

  describe "#grouped_categories" do
    let(:subcategory_names) do
      Pages::Navigation
        .find(sample_path)
        .children
        .map(&:subcategory)
        .compact
        .uniq
    end

    subject { grouped_categories(sample_path) }

    specify "returns a hash" do
      expect(subject).to be_a(Hash)
    end

    specify "the keys are subcategories" do
      expect(subject.keys).to match_array(subcategory_names)
    end

    specify "the groupings contain the right pages" do
      subcategory_names.each do |group|
        expect(subject[group].map(&:subcategory)).to all(eql(group))
      end
    end
  end
end
