require "rails_helper"
require "feedback_exporter"

RSpec.describe FeedbackExporter do
  let(:feedback) do
    [
      create(:user_feedback, topic: "TEST TOPIC", rating: :very_satisfied, explanation: "was great"),
      create(:user_feedback, topic: "TEST TOPIC", rating: :very_dissatisfied, explanation: "wasn't good"),
      create(:user_feedback, topic: "TEST TOPIC", rating: :satisfied, explanation: "was good"),
    ]
  end
  let(:instance) { described_class.new(feedback) }

  describe ".to_csv" do
    subject { instance.to_csv }

    it do
      expect(subject).to eq(
        <<~CSV,
          id,topic,rating,explanation,created_at
          #{feedback[0].id},TEST TOPIC,very_satisfied,was great,#{feedback[0].created_at}
          #{feedback[1].id},TEST TOPIC,very_dissatisfied,wasn't good,#{feedback[1].created_at}
          #{feedback[2].id},TEST TOPIC,satisfied,was good,#{feedback[2].created_at}
        CSV
      )
    end
  end
end
