FactoryBot.define do
  factory :degree_class, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Degree Class #{v}" }

    trait :upper_second do
      id { 222_750_002 }
      value { "2:1" }
    end
  end
end
