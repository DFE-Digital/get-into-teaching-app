FactoryBot.define do
  factory :event_api, class: Hash do
    skip_create
    initialize_with { attributes.stringify_keys }

    id { SecureRandom.uuid }
    typeId { 222_750_001 }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "Become a Teacher #{i} event description" }
    sequence(:startAt) { |i| i.weeks.from_now.xmlschema }
    endAt { startAt }
    eventType { 0 }
    maxCapacity { 10 }
    publicEventUrl { "https://event.url" }
    building { build :event_building_api }
    room { build :event_room_api }
  end
end
