require "rails_helper"

describe Content::YoutubeVideoComponent, type: :component do
  let(:id) { "abc123" }
  let(:title) { "Title" }
  let(:component) { described_class.new(id: id, title: title) }

  subject(:render) do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("iframe[src='https://www.youtube-nocookie.com/embed/#{id}']") }
  it { is_expected.to have_css("iframe[title=#{title}]") }
  it { is_expected.to have_css("iframe[loading=lazy]") }
  it { is_expected.to have_css("iframe[frameborder=0]") }
  it { is_expected.to have_css("iframe[allow='autoplay; encrypted-media']") }
  it { is_expected.to have_css("iframe[allowfullscreen]") }

  describe "validation" do
    context "when the id is not set" do
      let(:id) { nil }

      it { expect { render }.to raise_error(ArgumentError, "id must be present") }
    end

    context "when the title is not set" do
      let(:title) { nil }

      it { expect { render }.to raise_error(ArgumentError, "title must be present") }
    end
  end
end
