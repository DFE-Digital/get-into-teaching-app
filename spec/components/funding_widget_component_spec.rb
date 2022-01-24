require "rails_helper"

RSpec.describe FundingWidgetComponent, type: :component do
  let(:funding_widget) { FundingWidget.new }
  let(:path) { "/example-page" }

  let(:component) { described_class.new(funding_widget, path) }

  before { render_inline(component) }

  describe "rendering the component" do
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
          expect(page).to have_css("option[value='primary_with_english']", text: "Primary with English")
          expect(page).to have_css("option[value='languages']", text: "Languages (including ancient languages)")
        end
      end
    end

    describe "results" do
      let(:funding_widget) { FundingWidget.new(subject: "biology") }

      it "has a sub head" do
        expect(page).to have_css("h3", text: "Biology - Secondary")
      end

      it "has the 'Next steps' info" do
        expect(page).to have_css("h3", text: "Next steps")
      end

      it "has additional info for extra support" do
        expect(page).to have_css("p", text: "You may be able to get extra support")
      end
    end
  end

  describe "custom content" do
    let(:funding_widget) { FundingWidget.new(subject: "mathematics") }

    it "contains subject-specific funding content" do
      expect(page).to have_text("Scholarships of £26,000 and bursaries of £24,000 are available for trainee maths teachers.")
    end

    it "contains subject-specific next steps content" do
      expect(page).to have_text("Custom maths content goes here")
    end
  end
end
