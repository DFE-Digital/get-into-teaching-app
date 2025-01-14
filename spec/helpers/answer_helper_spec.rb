require "rails_helper"

RSpec.describe AnswerHelper, type: :helper do
  describe "#format_answer" do
    let(:time_zone) { "UTC" }

    before { allow(Time).to receive(:zone) { time_zone } }

    it "correctly formats a date" do
      answer = Date.new(2011, 1, 24)
      expect(helper.format_answer(answer)).to eq("<span>24 01 2011</span>")
    end

    it "correctly formats a time" do
      answer = Time.utc(2011, 1, 24, 10, 30)
      expect(helper.format_answer(answer)).to eq("<span>10:30am</span>")
    end

    it "correctly formats a time of midday" do
      answer = Time.utc(2011, 1, 24, 12, 0)
      expect(helper.format_answer(answer)).to eq("<span>Midday</span>")
    end

    it "correctly formats a time of midnight" do
      answer = Time.utc(2011, 1, 24, 0, 0)
      expect(helper.format_answer(answer)).to eq("<span>Midnight</span>")
    end

    it "calls safe_format" do
      answer = "test\ntest"
      expect(helper.format_answer(answer)).to eq("<span>test\n<br />test</span>")
    end

    context "when a time zone has been set" do
      let(:time_zone) { "Hawaii" }

      it "correctly formats a time" do
        answer = Time.utc(2011, 1, 24, 10, 30)
        expect(helper.format_answer(answer)).to eq("<span>12:30am</span>")
      end
    end
  end

  describe "#link_to_change_answer" do
    it "returns a link to the sign up step" do
      expect(link_to_change_answer(TeacherTrainingAdviser::Steps::Identity, "email")).to eq(
        "<a href=\"/teacher-training-adviser/sign_up/identity\">Change <span class=\"visually-hidden\"> your email</span></a>",
      )
    end
  end
end
