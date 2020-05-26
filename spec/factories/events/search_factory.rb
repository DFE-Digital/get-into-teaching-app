FactoryBot.define do
  factory :events_search, class: Events::Search do
    type { Events::Search::EVENT_TYPES.first }
    distance { Events::Search::DISTANCES.first }
    postcode { "TE57 1NG" }
    month { 1.month.from_now.to_date.to_formatted_s :yearmonth }
  end
end
