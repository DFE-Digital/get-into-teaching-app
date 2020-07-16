FactoryBot.define do
  factory :events_further_details, class: Events::Steps::FurtherDetails do
    event_id { "abc123" }
    privacy_policy { true }
    future_events { true }
    address_postcode { "TE57 1NG" }
  end
end
