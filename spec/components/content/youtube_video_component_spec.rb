require "rails_helper"

describe Content::YoutubeVideoComponent, type: :component do
  let(:id) { "abc123" }
  let(:title) { "Title" }
  let(:preview_image) { nil }
  let(:component) { described_class.new(id: id, title: title, preview_image: preview_image) }

  subject(:render) do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("iframe[data-youtube-video-target=video]") }
  it { is_expected.to have_css("iframe[src='https://www.youtube-nocookie.com/embed/#{id}?autoplay=0&mute=0']") }
  it { is_expected.to have_css("iframe[title=#{title}]") }
  it { is_expected.to have_css("iframe[loading=lazy]") }
  it { is_expected.to have_css("iframe[frameborder=0]") }
  it { is_expected.to have_css("iframe[allow='autoplay; encrypted-media']") }
  it { is_expected.to have_css("iframe[allowfullscreen]") }
  it { is_expected.not_to have_css("a") }
  it { is_expected.not_to have_css("img") }

  context "when a preview_image is specified" do
    let(:preview_image) { "media/images/content/blog/bedfordshire.jpg" }

    it { is_expected.to have_css("a.hidden") }
    it { is_expected.to have_css("a[data-action='youtube-video#play']") }
    it { is_expected.to have_css("a[data-youtube-video-target=preview]") }
    it { is_expected.to have_css("a img[src*='packs-test/v1/media/images/content/blog/bedfordshire']") }
    it { is_expected.to have_css("iframe[src='https://www.youtube-nocookie.com/embed/#{id}?autoplay=1&mute=1']") }
  end

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
