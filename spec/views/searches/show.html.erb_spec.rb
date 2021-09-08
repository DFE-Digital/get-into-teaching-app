require "rails_helper"

describe "searches/show.html.erb", type: :view do
  subject { rendered }

  before { allow(model).to receive(:results).and_return results }

  before { assign(:search, model) && render }

  let(:model) { Search.new }
  let(:results) { nil }

  it { is_expected.to have_css "h1", text: "Search Get Into Teaching" }
  it { is_expected.to have_css %(form input[name="search[search]"]) }
  it { is_expected.not_to have_css "h2" }

  context "without a search" do
    it { is_expected.not_to have_css "h3" }
    it { is_expected.not_to have_css "p em" }
  end

  context "with search term" do
    context "with no results" do
      let(:results) { {} }

      it { is_expected.to have_css "p em" }
      it { is_expected.not_to have_css "h3" }
    end

    context "with some results" do
      let(:results) do
        [
          { path: "/page1", front_matter: { title: "Page 1" } },
          { path: "/page1", front_matter: { title: "Page 1" } },
        ]
      end

      it { is_expected.to have_css "p" }
      it { is_expected.not_to have_css "p em" }
      it { is_expected.to have_css "h3", count: 2 }
    end
  end
end
