FactoryBot.define do
  factory :events_search, class: "Events::Search" do
    type { Events::Search.available_event_types.last.id }
    distance { Events::Search.available_distances.first[0] }
    postcode { "TE57 1NG" }
    month { "2020-07" }

    trait :invalid do
      distance { 20 }
      postcode { nil }
    end
  end
end
