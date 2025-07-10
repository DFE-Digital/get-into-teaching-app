FactoryBot.define do
  factory :situation, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Situation #{v}" }

    trait :in_education do
      id { 222_750_000 }
      value { "16-18 years old and still in education" }
    end

    trait :on_break do
      id { 222_750_001 }
      value { "On a break before starting university" }
    end

    trait :first_career do
      id { 222_750_002 }
      value { "Exploring options for my first career" }
    end

    trait :graduated do
      id { 222_750_003 }
      value { "Graduated and exploring my career options" }
    end

    trait :change_career do
      id { 222_750_004 }
      value { "Considering changing my existing career" }
    end

    trait :teaching_assistant do
      id { 222_750_005 }
      value { "Teaching assistant or unqualified teacher in a school" }
    end

    trait :not_working do
      id { 222_750_006 }
      value { "Not currently working" }
    end

    trait :qualified_teacher do
      id { 222_750_007 }
      value { "Qualified teacher" }
    end
  end
end
