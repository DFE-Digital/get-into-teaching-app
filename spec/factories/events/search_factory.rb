FactoryBot.define do
  factory :events_search, class: Events::Search do
    type { Events::Search.new.available_event_types.first.id }
    distance { Events::Search.new.available_distances.first[0] }
    postcode { "TE57 1NG" }
    month { Events::Search.new.available_months.first[0] }
  end
end
