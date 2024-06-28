FactoryBot.define do
  factory :user_feedback do
    topic { "website" }
    explanation { "TEST EXPLANATION" }
    rating { :very_satisfied }
  end
end
