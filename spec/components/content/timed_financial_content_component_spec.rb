# frozen_string_literal: true

require "rails_helper"

RSpec.describe Content::TimedFinancialContentComponent, type: :component do
  # The component chooses which content to show based on `now` and the windows
  # configured in its private `content_dates`:
  #
  #   * "2025" branch  -> now on or before 2026-09-28
  #   * "2026" branch  -> now on or after  2026-10-06
  #   * "default"      -> the gap in between (and any time with no matching branch)
  #
  # `now` defaults to Time.current, but is injectable so the branch selection can
  # be exercised without travelling through time. The values below sit
  # comfortably inside each window.
  let(:now_in_2025_window) { Time.zone.parse("2026-06-01") }
  let(:now_in_2026_window) { Time.zone.parse("2026-11-01") }
  let(:now_in_gap) { Time.zone.parse("2026-09-30") }

  describe "the default branch" do
    it "renders nothing when no arguments are given" do
      expect(render_inline(described_class.new).to_html.strip).to eq("")
    end

    it "renders the default text whenever there are no conditional branches" do
      component = described_class.new(now: now_in_gap, default: { text: "Fallback copy" })

      expect(render_inline(component).to_html).to include("Fallback copy")
    end

    it "falls back to the default when the current window has no configured branch" do
      component = described_class.new(
        now: now_in_2026_window,
        default: { text: "Fallback copy" },
        "2025": { text: "2025 copy" },
      )

      expect(render_inline(component).to_html).to include("Fallback copy")
    end
  end

  describe "selecting a conditional branch by time" do
    subject(:rendered) { render_inline(component).to_html }

    let(:component) do
      described_class.new(
        now: now,
        default: { text: "Default copy" },
        "2025": { text: "2025 copy" },
        "2026": { text: "2026 copy" },
      )
    end

    context "when now is within the 2025 window" do
      let(:now) { now_in_2025_window }

      it { is_expected.to include("2025 copy") }
    end

    context "when now is within the 2026 window" do
      let(:now) { now_in_2026_window }

      it { is_expected.to include("2026 copy") }
    end

    context "when now falls in the gap between windows" do
      let(:now) { now_in_gap }

      it { is_expected.to include("Default copy") }
    end
  end

  describe "window boundaries" do
    subject(:rendered) { render_inline(component).to_html }

    let(:component) do
      described_class.new(
        now: now,
        default: { text: "Default copy" },
        "2025": { text: "2025 copy" },
        "2026": { text: "2026 copy" },
      )
    end

    context "when now is exactly the 2025 valid_to date" do
      let(:now) { Time.zone.parse("2026-09-28") }

      it "is inclusive and renders the 2025 branch" do
        expect(rendered).to include("2025 copy")
      end
    end

    context "when now is the day after the 2025 window closes" do
      let(:now) { Time.zone.parse("2026-09-29") }

      it { is_expected.to include("Default copy") }
    end

    context "when now is the day before the 2026 window opens" do
      let(:now) { Time.zone.parse("2026-10-05") }

      it { is_expected.to include("Default copy") }
    end

    context "when now is exactly the 2026 valid_from date" do
      let(:now) { Time.zone.parse("2026-10-06") }

      it "is inclusive and renders the 2026 branch" do
        expect(rendered).to include("2026 copy")
      end
    end
  end

  describe "integer branch keys (as parsed from YAML front matter)" do
    let(:component) do
      described_class.new(
        now: now_in_2026_window,
        default: { text: "Default copy" },
        2025 => { text: "2025 copy" },
        2026 => { text: "2026 copy" },
      )
    end

    it "coerces integer keys to strings and matches the current window" do
      expect(render_inline(component).to_html).to include("2026 copy")
    end
  end

  describe "rendering a partial instead of text" do
    let(:partial) { "content/shared/qualifications-training/get_school_experience" }

    it "renders the branch partial when one is configured" do
      component = described_class.new(
        now: now_in_2025_window,
        default: { text: "Default copy" },
        "2025": { text: "2025 copy", partial: partial },
      )

      rendered = render_inline(component).to_html

      expect(rendered).to include("Get school experience")
      expect(rendered).not_to include("2025 copy")
    end

    it "renders the default partial when the default branch is selected" do
      component = described_class.new(now: now_in_gap, default: { partial: partial })

      expect(render_inline(component).to_html).to include("Get school experience")
    end
  end

  # Branch text is rendered as markdown, and $token$ placeholders are
  # substituted for their values, so it reads the same as when the component was
  # baked into the page and processed by the markdown pipeline.
  describe "rendering text" do
    it "renders the text as markdown" do
      component = described_class.new(
        now: now_in_gap,
        default: { text: "Some **bold** and a [link](/events)." },
      )

      html = render_inline(component).to_html

      expect(html).to include("<strong>bold</strong>")
      expect(html).to include('<a href="/events">link</a>')
    end

    it "substitutes $token$ placeholders for their values" do
      allow(Value).to receive(:get).with("myamount").and_return("£9,000")
      component = described_class.new(now: now_in_gap, default: { text: "You get $myamount$ a year." })

      expect(render_inline(component).to_html).to include("You get £9,000 a year.")
    end

    it "emits text that is already html_safe as-is (e.g. from ERB)" do
      safe = "<em>already safe</em>".html_safe
      component = described_class.new(now: now_in_gap, default: { text: safe })

      expect(render_inline(component).to_html).to include("<em>already safe</em>")
    end

    it "wraps text in its own block-level markup so it does not run into the heading" do
      component = described_class.new(now: now_in_gap, default: { text: "Just one line." })

      expect(render_inline(component).to_html.strip).to eq("<p>Just one line.</p>")
    end

    it "keeps paragraph tags for multi-paragraph text" do
      component = described_class.new(now: now_in_gap, default: { text: "First para.\n\nSecond para." })

      html = render_inline(component).to_html
      expect(html).to include("<p>First para.</p>")
      expect(html).to include("<p>Second para.</p>")
    end
  end

  # In "text" format the branch text is substituted but not run through
  # Kramdown, so the output has no wrapping tags and is suitable for contexts
  # like a <meta> description where markup would leak into an attribute.
  describe "rendering text in the 'text' format" do
    it "substitutes $token$ placeholders without wrapping the text in markup" do
      allow(Value).to receive(:get).with("myamount").and_return("£9,000")
      component = described_class.new(
        now: now_in_gap,
        format: "text",
        default: { text: "You get $myamount$ a year." },
      )

      html = render_inline(component).to_html

      expect(html).to include("You get £9,000 a year.")
      expect(html).not_to include("<p>")
    end

    it "still selects the branch by time" do
      component = described_class.new(
        now: now_in_2026_window,
        format: "text",
        default: { text: "Default copy" },
        "2025": { text: "2025 copy" },
        "2026": { text: "2026 copy" },
      )

      expect(render_inline(component).to_html).to include("2026 copy")
    end

    it "defaults to the markdown-rendered 'html' format when no format is given" do
      component = described_class.new(now: now_in_gap, default: { text: "Just one line." })

      expect(render_inline(component).to_html.strip).to eq("<p>Just one line.</p>")
    end
  end

  describe "the default value for now" do
    it "uses Time.current when no now argument is supplied" do
      travel_to now_in_2026_window do
        component = described_class.new(
          default: { text: "Default copy" },
          "2025": { text: "2025 copy" },
          "2026": { text: "2026 copy" },
        )

        expect(render_inline(component).to_html).to include("2026 copy")
      end
    end
  end

  # For debugging we can override which branch renders, without waiting for a
  # date. The branch can be forced directly (the `branch:` argument or the
  # `branch` param), or indirectly by overriding the clock (the `now` param).
  # A forced branch wins over a `now` override, which wins over the real date.
  # All of these overrides are honoured everywhere except production (see the
  # "when the environment is production" section below).
  describe "overriding the selected branch" do
    subject(:rendered) { render_inline(component).to_html }

    let(:component) do
      described_class.new(
        now: now, # sits in the 2025 window, so the date alone would pick "2025"
        branch: branch,
        default: { text: "Default copy" },
        "2025": { text: "2025 copy" },
        "2026": { text: "2026 copy" },
      )
    end

    let(:now) { now_in_2025_window }
    let(:branch) { nil }

    context "with the branch: argument" do
      let(:branch) { "2026" }

      it "renders the forced branch, ignoring the date-based selection" do
        expect(rendered).to include("2026 copy")
        expect(rendered).not_to include("2025 copy")
      end
    end

    context "with the branch request param" do
      it "renders the branch named in the param, overriding the date" do
        with_request_url("/?branch=2026") do
          expect(rendered).to include("2026 copy")
          expect(rendered).not_to include("2025 copy")
        end
      end
    end

    context "when both the branch param and the branch: argument are given" do
      let(:branch) { "default" }

      it "lets the param win over the argument" do
        with_request_url("/?branch=2026") do
          expect(rendered).to include("2026 copy")
        end
      end
    end

    context "when the override names a branch that is not configured" do
      let(:branch) { "does-not-exist" }

      it "falls back to the default branch" do
        expect(rendered).to include("Default copy")
      end
    end

    context "with the now request param" do
      it "selects the branch for the overridden time, overriding the real date" do
        with_request_url("/?now=2026-11-01") do
          expect(rendered).to include("2026 copy")
          expect(rendered).not_to include("2025 copy")
        end
      end
    end

    context "when both a branch override and a now override are given" do
      it "lets the branch override win over the now override" do
        with_request_url("/?branch=default&now=2026-11-01") do
          expect(rendered).to include("Default copy")
          expect(rendered).not_to include("2026 copy")
        end
      end
    end

    context "when no override is supplied" do
      it "falls back to the date-based selection from now" do
        expect(rendered).to include("2025 copy")
        expect(rendered).not_to include("Default copy")
      end
    end

    context "when the now param is malformed" do
      # now sits in the 2025 window, so a broken override should leave us there.
      it "falls back to the date when the param is unparseable (parses to nil)" do
        with_request_url("/?now=broken") do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("Default copy")
        end
      end

      it "falls back to the date when the param is out of range (raises)" do
        with_request_url("/?now=2026-13-99") do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("Default copy")
        end
      end

      it "falls back to the date when the param is a non-string shape (e.g. ?now[]=x)" do
        with_request_url("/?now[]=2026-11-01") do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("Default copy")
        end
      end
    end

    context "when the environment is production" do
      before { allow(Rails.env).to receive(:production?).and_return(true) }

      it "ignores the branch param and uses the date-based selection" do
        with_request_url("/?branch=2026") do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("2026 copy")
        end
      end

      it "ignores the now param and uses the date-based selection" do
        with_request_url("/?now=2026-11-01") do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("2026 copy")
        end
      end

      context "with the branch: argument" do
        let(:branch) { "2026" }

        it "ignores the branch: argument and uses the date-based selection" do
          expect(rendered).to include("2025 copy")
          expect(rendered).not_to include("2026 copy")
        end
      end
    end
  end

  describe "the configured content dates" do
    it "has a valid_from that is before the valid_to (nils are allowed for either)" do
      described_class.content_dates.each do |content_date|
        valid_from = content_date[:valid_from]
        valid_to = content_date[:valid_to]

        next if valid_from.nil? || valid_to.nil?

        expect(valid_from).to be < valid_to
      end
    end
  end
end
