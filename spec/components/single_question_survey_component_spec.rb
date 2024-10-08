require "rails_helper"

RSpec.describe SingleQuestionSurveyComponent, type: :component do
  describe "rendering the component" do
    let(:question) { "What is your favourite colour?" }
    let(:answers) { %w[red blue green] }
    let(:component) { described_class.new(question: question, answers: answers) }

    before { render_inline(component) }

    describe "quesiton" do
      it "renders the question in a heading" do
        expect(page).to have_css("h2", text: "What is your favourite colour?")
      end
    end

    describe "answers" do
      it "renders all the answers" do
        expect(page).to have_button("red")
        expect(page).to have_button("blue")
        expect(page).to have_button("green")
        expect(page).to have_css("button", count: 3)
      end
    end

    describe "hint" do
      context "when provided" do
        let(:hint) { "Choose one of the following" }
        let(:component) { described_class.new(question: question, hint: hint, answers: answers) }

        it "renders a hint" do
          expect(page).to have_css("div.govuk-hint", text: "Choose one of the following")
        end
      end

      context "when not provided" do
        it "renders an empty hint" do
          expect(page).to have_css("div.govuk-hint", text: "")
        end
      end
    end
  end
end
