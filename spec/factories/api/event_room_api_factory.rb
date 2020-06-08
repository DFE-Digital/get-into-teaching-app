FactoryBot.define do
  factory :event_room_api, class: Hash do
    skip_create
    initialize_with { attributes.stringify_keys }

    id { SecureRandom.uuid }
    description { "Lecture Hall 1 description" }
    name { "Lecture Hall 1" }
    disabledAccess { true }
  end
end
