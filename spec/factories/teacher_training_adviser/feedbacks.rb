FactoryBot.define do
  factory :feedback, class: "TeacherTrainingAdviser::Feedback" do
    rating { :satisfied }
    successful_visit { true }
    unsuccessful_visit_explanation { nil }
    improvements { nil }
  end
end
