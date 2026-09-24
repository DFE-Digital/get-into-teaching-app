require "rails_helper"

describe PagesController, type: :request do
  describe "#show" do
    context "with unknown page" do
      subject { response }

      before { get "/testing/unknown" }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end

    context "with cookies page" do
      subject { response }

      before { get "/cookies" }

      it { is_expected.to have_http_status(:success) }
    end

    context "with a noindexed page" do
      subject { response }

      before { get "/landing/advisers" }

      it { is_expected.not_to be_indexed }
    end

    context "with mailing list landing page" do
      subject { response }

      before { get "/landing/mailing-list" }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes body: /Get the latest information sent straight to your inbox/i }
    end

    context "with a page that has a timed financial description" do
      subject(:meta_description) do
        Nokogiri::HTML(response.body).at('meta[name="description"]')&.[]("content")
      end

      context "when in the 2025 funding window" do
        before { get "/landing/how-to-fund-your-teacher-training?branch=2025" }

        it "renders the timed description advertising the scholarship amount" do
          expect(meta_description).to include("scholarships available up to")
        end

        it "renders it as plain text, without wrapping markup leaking into the tag" do
          expect(meta_description).not_to include("<p>")
        end
      end

      context "when outside the funding windows" do
        before { get "/landing/how-to-fund-your-teacher-training?branch=default" }

        it "falls back to the default description without the amount" do
          expect(meta_description).to include("bursaries, depending")
          expect(meta_description).not_to include("available up to")
        end
      end
    end

    # The steps on this page render TimedFinancialContentComponent from an ERB
    # partial (inside the `steps` component), so the whole `steps` component has
    # to be a runtime component - otherwise its content is baked at
    # template-compile time and never reflects the funding window or the
    # ?now=/?branch= overrides.
    context "with a page whose steps contain timed financial content" do
      subject(:funding_step) { response.body }

      context "when the 2025 funding window is forced" do
        before { get "/steps-to-become-a-teacher?branch=2025" }

        it "renders the windowed copy advertising the amount" do
          expect(funding_step).to include("bursary or scholarship of up to")
        end

        # The step partials render per-request now, so any $value$ placeholder in
        # them must use the ERB helper - it no longer gets the markdown handler's
        # compile-time substitution pass.
        it "substitutes value placeholders in the step partial" do
          expect(funding_step).to include("teacher training course fees are around #{Value.get('fees_pgittandugitt')} per year")
          expect(funding_step).not_to match(/\$[a-zA-Z0-9_]+\$/)
        end
      end

      context "when the default branch is forced" do
        before { get "/steps-to-become-a-teacher?branch=default" }

        it "renders the default copy without the amount" do
          expect(funding_step).to include("might be able to get a tax-free bursary to support you")
          expect(funding_step).not_to include("bursary or scholarship of up to")
        end
      end
    end

    context "with invalid page" do
      subject { response }

      before do
        allow_any_instance_of(described_class).to \
          receive(:render).with(status: :not_found, body: nil).and_call_original

        get "/../../secrets.txt"
      end

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: "" }
    end
  end

  describe "#filtered_page_template" do
    subject { controller.send(:filtered_page_template, template) }

    let(:controller) { described_class.new }

    context "with valid page template" do
      let(:template) { "hello" }

      it { is_expected.to eql "hello" }
    end

    context "with nested template" do
      let(:template) { "hello/world" }

      it { is_expected.to eql "hello/world" }
    end

    context "with invalid page template" do
      let(:template) { "invalid!" }

      it { expect { subject }.to raise_exception described_class::InvalidTemplateName }
    end

    context "with param linking to parent page" do
      let(:template) { "../../secrets.txt" }

      it { expect { subject }.to raise_exception described_class::InvalidTemplateName }
    end

    context "with file extension" do
      let(:template) { "stories/how-i-got-into-teaching.html" }

      it { is_expected.to eql "stories/how-i-got-into-teaching.html" }
    end

    context "with numbers in name" do
      let(:template) { "stories/my-top-10" }

      it { is_expected.to eql "stories/my-top-10" }
    end
  end

  # `caches_page :show` is gated on this predicate so that pages using a runtime
  # component (which must render per-request) are never served from a static
  # page cache.
  describe "#page_uses_runtime_component?" do
    subject { controller.send(:page_uses_runtime_component?) }

    let(:controller) { described_class.new }

    context "when no page has been resolved" do
      it { is_expected.to be false }
    end

    context "when the page's front matter declares a runtime component" do
      before do
        controller.instance_variable_set(
          :@page,
          Pages::Page.new("/example", "timed_financial_content" => { "compare" => { "default" => { "text" => "x" } } }),
        )
      end

      it { is_expected.to be true }
    end

    context "when the page's front matter has no runtime component" do
      before do
        controller.instance_variable_set(
          :@page,
          Pages::Page.new("/example", "title" => "A static page", "expander" => { "e1" => {} }),
        )
      end

      it { is_expected.to be false }
    end
  end
end
