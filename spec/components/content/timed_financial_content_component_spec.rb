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
