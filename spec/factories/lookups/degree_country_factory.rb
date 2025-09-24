FactoryBot.define do
  factory :degree_country, class: "GetIntoTeachingApiClient::Country" do
    id { SecureRandom.uuid }
    sequence(:value) { |v| "Degree Country #{v}" }

    trait :uk do
      id { '72f5c2e6-74f9-e811-a97a-000d3a2760f2' }
      value { "United Kingdom" }
    end

    trait :another_country do
      id { '6f9e7b81-e44d-f011-877a-00224886d23e' }
      value { "Another Country" }
    end
  end
end
