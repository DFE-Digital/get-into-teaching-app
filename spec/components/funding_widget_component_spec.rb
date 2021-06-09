require "rails_helper"

RSpec.describe FundingWidgetComponent, type: :component do
  describe "rendering the component" do
    let(:funding_widget) { FundingWidget.new }
    let(:path) { "/example-page" }

    let(:component) { described_class.new(funding_widget, path) }
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
          expect(page).to have_css("optgroup[label='Secondary: Modern languages']")
          expect(page).to have_css("option[value='primary_with_english']", text: "Primary with English")
          expect(page).to have_css("option[value='french']", text: "French")
        end
      end
    end

    describe "results" do
      let(:funding_widget) { FundingWidget.new(subject: "biology") }

      it "has a sub head" do
        expect(page).to have_css("h3", text: "Biology - Secondary")
      end

      it "has the 'Next Steps' info" do
        expect(page).to have_css("h3", text: "Next Steps")
      end

      it "has additional info for extra support" do
        expect(page).to have_css("p", text: "You may be able to get extra support")
      end

      it "has the urgency notice" do
        expect(page).to have_css("h3", text: "Start your teacher training this September")
        expect(page).to have_css("div", text: "There's still time to find funding and complete an application. We can help you get ready.")
        expect(page).to have_link(href: "/start-teacher-training-this-september")
      end
    end
  end
end
