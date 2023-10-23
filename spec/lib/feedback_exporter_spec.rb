require "rails_helper"
require "feedback_exporter"

RSpec.describe FeedbackExporter do
  let(:feedback) do
    [
      create(:user_feedback, topic: "TEST TOPIC", rating: :very_satisfied, explanation: " =cmd|' /C notepad'!'A1'"),
      create(:user_feedback, topic: "TEST TOPIC", rating: :very_dissatisfied, explanation: "wasn't good"),
      create(:user_feedback, topic: "TEST TOPIC", rating: :satisfied, exaplanation: "was good"),
    ]
  end
  let(:instance) { described_class.new(feedback) }

  describe ".to_csv" do
    subject { instance.to_csv }

    it do
      expect(subject).to eq(
        <<~CSV,
          id,topic,explanation,rating,created_at
          #{feedback[0].id},TEST TOPIC,"",very_satisfied,#{feedback[0].created_at}
          #{feedback[1].id},TEST TOPIC,wasn't good,very_dissatisfied,#{feedback[1].created_at}
          #{feedback[2].id},TEST TOPIC,satisfied,was good,#{feedback[2].created_at}
        CSV
      )
    end
  end
end
