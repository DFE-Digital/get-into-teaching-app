FactoryBot.define do
  factory :event_api, class: GetIntoTeachingApiClient::TeachingEvent do
    id { SecureRandom.uuid }
    sequence(:readable_id, &:to_s)
    type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }
    web_feed_id { "123" }
    status_id { GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"] }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "Become a Teacher #{i} event description" }
    sequence(:summary) { |i| "Become a Teacher #{i} event summary" }
    message { "An important message" }
    video_url { "https://video.com" }
    sequence(:start_at) { |i| i.weeks.from_now }
    end_at { start_at + 2.hours }
    is_online { false }
    building { build :event_building_api }

    trait :closed do
      status_id { GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"] }
    end

    trait :with_provider_info do
      provider_website_url { "https://event-provider.com" }
      provider_target_audience { "Anyone interested in teaching from Sept 2021" }
      provider_organiser { "United Teaching" }
      provider_contact_email { "jim@smith.com" }
    end

    trait :application_workshop do
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Application Workshop"] }
    end

    trait :train_to_teach_event do
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }
    end

    trait :online_event do
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }
    end

    trait :no_event_type do
      type_id { nil }
    end

    trait :no_location do
      building { nil }
    end
  end
end
