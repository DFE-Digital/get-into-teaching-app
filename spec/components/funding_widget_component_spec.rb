require "rails_helper"

RSpec.describe FundingWidgetComponent, type: :component do
  let(:funding_widget) { FundingWidget.new }
  let(:path) { "/example-page" }

  let(:component) { described_class.new(funding_widget, path) }

  describe "rendering the component" do
    before { render_inline(component) }

    it "builds a funding_widget form" do
      expect(page).to have_css("form[action='#{path}'][method='get']")
    end

    describe "error messages" do
      it "renders the error messages" do
        component.error_messages.each do |message|
          expect(page).to have_css("div", text: message)
        end
      end
    end

    describe "form fields" do
      describe "subject" do
        it "is present" do
          expect(page).to have_css("select[name='funding_widget[subject]']")
        end

        it "is correctly-labelled" do
          expect(page).to have_css("label[for='funding_widget_subject']")
          expect(page).to have_css("select[id='funding_widget_subject']")
        end

        it "is populated correclty" do
          expect(page).to have_css("optgroup[label='Primary']")
          expect(page).to have_css("optgroup[label='Secondary']")
          expect(page).to have_css("option[value='primary']", text: "Primary (all subjects)")
          expect(page).to have_css("option[value='languages']", text: "Languages (including ancient languages)")
        end
      end
    end

    describe "results" do
      let(:funding_widget) { FundingWidget.new(subject: "biology") }

      it "has a sub head" do
        expect(page).to have_css("h3", text: "Biology - Secondary")
      end
    end
  end

  describe "custom content" do
    let(:funding_widget) { FundingWidget.new(subject: "maths") }

    context "when subject is maths" do
      before { with_request_url("/?branch=2025") { render_inline(component) } }

      it "contains subject-specific funding content for the active window" do
        expect(page).to have_text("Bursaries of £29,000 are available for trainee maths teachers if you’re eligible.")
      end
    end

    context "when the content contains %{variables}" do
      before do
        I18n.with_locale(:test) do
          render_inline(component)
        end
      end

      it "substitutes the variable for a value in sub heading" do
        expect(page).to have_text("Maths - starting salary: £34,000")
      end

      it "substitutes the variable for a value in funding content" do
        expect(page).to have_text("Bursaries of £29,000 are available.")
      end
    end
  end

  describe "timed funding content" do
    let(:funding_widget) { FundingWidget.new(subject: "maths") }

    context "when the 2025 funding window is active" do
      before { with_request_url("/?branch=2025") { render_inline(component) } }

      it "renders the 2025 branch copy" do
        expect(page).to have_text("Bursaries of £29,000 are available for trainee maths teachers")
      end

      it "does not render the default branch copy" do
        expect(page).to have_no_text("Bursaries are available for trainee maths teachers")
      end
    end

    context "when no funding window is active (default branch)" do
      before { with_request_url("/?branch=default") { render_inline(component) } }

      it "falls back to the default branch copy" do
        expect(page).to have_text("Bursaries are available for trainee maths teachers")
      end

      it "does not render the windowed amount" do
        expect(page).to have_no_text("Bursaries of £29,000")
      end
    end
  end

  describe "a subject with no funding" do
    let(:funding_widget) { FundingWidget.new(subject: "primary") }

    before { render_inline(component) }

    it "reports no funding results" do
      expect(component.funding_results).to be_empty
    end

    it "renders the 'not available' primary copy" do
      expect(page).to have_text("Scholarships or bursaries are not available for primary school teacher training.")
    end
  end

  describe "debugging override fields" do
    let(:funding_widget) { FundingWidget.new(subject: "maths") }

    context "when branch and now params are present" do
      before { with_request_url("/?branch=2025&now=2026-06-01") { render_inline(component) } }

      it "carries the branch param through a hidden field" do
        expect(page).to have_css("input[type='hidden'][name='branch'][value='2025']", visible: :all)
      end

      it "carries the now param through a hidden field" do
        expect(page).to have_css("input[type='hidden'][name='now'][value='2026-06-01']", visible: :all)
      end
    end

    context "when no override params are present" do
      before { render_inline(component) }

      it "does not render the branch hidden field" do
        expect(page).to have_no_css("input[name='branch']", visible: :all)
      end

      it "does not render the now hidden field" do
        expect(page).to have_no_css("input[name='now']", visible: :all)
      end
    end
  end
end
