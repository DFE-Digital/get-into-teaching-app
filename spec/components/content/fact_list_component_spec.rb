require "rails_helper"

describe Content::FactListComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:fact1) do
    {
      icon: "icon-money",
      value: "value1",
      title: "title1",
      link: "<a href='/'>link1</a>",
    }
  end
  let(:fact2) do
    {
      icon: "icon-money",
      value: "value2",
      title: "title2",
      link: "<a href='/'>link2</a>",
    }
  end
  let(:facts) { [fact1, fact2] }
  let(:component) { described_class.new(facts) }

  it { is_expected.to have_css("ul.fact-list") }
  it { is_expected.to have_css("li", count: facts.count) }

  it "renders facts" do
    facts.each.with_index do |fact, idx|
      within(render.all("li")[idx]) do
        it { is_expected.to have_css("img", src: fact[:icon]) }
        it { is_expected.to have_css("strong", text: fact[:value]) }
        it { is_expected.to have_css("p", text: fact[:title]) }
        it { is_expected.to have_css("a") }
      end
    end
  end

  describe "validation" do
    context "when the icon is not set" do
      before { fact1[:icon] = nil }

      it { expect { render }.to raise_error(ArgumentError, "icon must be present for fact 1") }
    end

    context "when the value is not set" do
      before { fact2[:value] = " " }

      it { expect { render }.to raise_error(ArgumentError, "value must be present for fact 2") }
    end

    context "when the title is not set" do
      before { fact1[:title] = "" }

      it { expect { render }.to raise_error(ArgumentError, "title must be present for fact 1") }
    end

    context "when the link is not set" do
      before { fact2[:link] = nil }

      it { expect { render }.to raise_error(ArgumentError, "link must be present for fact 2") }
    end
  end
end
