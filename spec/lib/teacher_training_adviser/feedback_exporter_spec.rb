require "rails_helper"
require "teacher_training_adviser/feedback_exporter"

RSpec.describe TeacherTrainingAdviser::FeedbackExporter do
  let(:feedback) do
    [
      create(:feedback, rating: :very_satisfied, successful_visit: true, improvements: " =cmd|' /C notepad'!'A1'"),
      create(:feedback, rating: :very_dissatisfied, successful_visit: false, unsuccessful_visit_explanation: "wasn't good"),
      create(:feedback, rating: :satisfied, successful_visit: true),
    ]
  end
  let(:instance) { described_class.new(feedback) }

  describe ".to_csv" do
    subject { instance.to_csv }

    it do
      expect(subject).to eq(
        <<~CSV,
          id,rating,successful_visit,unsuccessful_visit_explanation,improvements,created_at
          #{feedback[0].id},very_satisfied,true,"",'=cmd|' /C notepad'!'A1',#{feedback[0].created_at}
          #{feedback[1].id},very_dissatisfied,false,wasn't good,"",#{feedback[1].created_at}
          #{feedback[2].id},satisfied,true,"","",#{feedback[2].created_at}
        CSV
      )
    end
  end
end
