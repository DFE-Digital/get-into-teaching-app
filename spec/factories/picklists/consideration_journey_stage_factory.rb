FactoryBot.define do
  factory :consideration_journey_stage, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Consideration Journey Stage #{v}" }

    trait :just_an_idea do
      id { 222_750_000 }
      value { "It's just an idea" }
    end

    trait :not_sure_and_finding_out_more do
      id { 222_750_001 }
      value { "I'm not sure and finding out more" }
    end

    trait :fairly_sure_and_exploring_options do
      id { 222_750_002 }
      value { "I'm fairly sure and exploring my options" }
    end

    trait :very_sure_and_will_apply do
      id { 222_750_003 }
      value { "I'm very sure and think I'll apply" }
    end
  end
end
