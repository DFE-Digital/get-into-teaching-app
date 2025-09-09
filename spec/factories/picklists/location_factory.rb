FactoryBot.define do
  factory :location, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Location #{v}" }

    trait :united_kingdom do
      id { 222_750_000 }
      value { "United Kingdom" }
    end

    trait :outside_united_kingdom do
      id { 222_750_001 }
      value { "Outside United Kingdom" }
    end
  end
end
