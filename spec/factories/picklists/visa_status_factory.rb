FactoryBot.define do
  factory :visa_status, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Visa Status #{v}" }

    trait :yes_i_have_a_visa do
      id { 222_750_000 }
      value { "Yes, I have a visa, pre-settled status or leave to remain" }
    end

    trait :no_i_will_need_to_apply_for_a_visa do
      id { 222_750_001 }
      value { "No, I will need to apply for a visa" }
    end

    trait :not_sure do
      id { 222_750_002 }
      value { "Not sure" }
    end
  end
end
