FactoryBot.define do
  factory :event_api, class: GetIntoTeachingApiClient::TeachingEvent do
    id { SecureRandom.uuid }
    sequence(:readable_id, &:to_s)
    type_id { GetIntoTeachingApi::Constants::EVENT_TYPES["Train to Teach event"] }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "Become a Teacher #{i} event description" }
    sequence(:start_at) { |i| i.weeks.from_now }
    end_at { start_at }
    building { build :event_building_api }
  end
end
