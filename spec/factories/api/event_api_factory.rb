FactoryBot.define do
  factory :event_api, class: Hash do
    skip_create
    initialize_with { attributes.stringify_keys }

    eventId { SecureRandom.uuid }
    readableEventId { eventId }
    sequence(:eventName) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "Become a Teacher #{i} event description" }
    sequence(:startDate) { |i| i.weeks.from_now.to_date.to_formatted_s(:db) }
    endDate { startDate }
    eventType { 0 }
    maxCapacity { 10 }
    publicEventUrl { "https://event.url" }
    building { build :event_building_api }
    room { build :event_room_api }
  end
end
