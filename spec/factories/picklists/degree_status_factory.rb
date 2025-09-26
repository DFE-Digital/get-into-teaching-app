FactoryBot.define do
  factory :degree_status, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { |v| "Degree Status #{v}" }

    trait :graduate_or_postgraduate do
      id { 222_750_000 }
      value { "Graduate or postgraduate" }
    end

    trait :final_year do
      id { 222_750_001 }
      value { "Final year" }
    end

    trait :second_year do
      id { 222_750_002 }
      value { "Second year" }
    end

    trait :first_year do
      id { 222_750_003 }
      value { "First year" }
    end

    trait :no_degree do
      id { 222_750_004 }
      value { "I don't have a degree and am not studying for one" }
    end

    trait :not_yet_im_studying do
      id { 222_750_006 }
      value { "Not yet, I'm studying for one" }
    end
  end
end
