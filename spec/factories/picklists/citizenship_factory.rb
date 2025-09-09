FactoryBot.define do
  factory :citizenship, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Citizenship #{v}" }

    trait :uk_citizen do
      id { 222_750_000 }
      value { "UK citizen" }
    end

    trait :non_uk_citizen do
      id { 222_750_001 }
      value { "Non-UK citizen" }
    end
  end
end
