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
      before { render_inline(component) }

      it "contains subject-specific funding content", skip: "Temporarily removed" do
        expect(page).to have_text("Scholarships of £30,000 and bursaries of £28,000 are available for trainee maths teachers if you're eligible.")
      end
    end

    context "when the content contains %{variables}" do
      before do
        I18n.with_locale(:test) do
          render_inline(component)
        end
      end

      it "substitutes the variable for a value in sub heading" do
        expect(page).to have_text("Maths - starting salary: £31,650")
      end

      it "substitutes the variable for a value in funding content", skip: "Temporarily removed" do
        expect(page).to have_text("Bursaries of £28,000 are available.")
      end
    end
  end
end
