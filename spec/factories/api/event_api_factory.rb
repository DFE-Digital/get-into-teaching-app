FactoryBot.define do
  factory :event_api, class: GetIntoTeachingApiClient::TeachingEvent do
    id { SecureRandom.uuid }
    sequence(:readable_id, &:to_s)
    type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "Become a Teacher #{i} event description" }
    message { "An important message" }
    video_url { "https://video.com" }
    sequence(:start_at) { |i| i.weeks.from_now }
    end_at { start_at }
    building { build :event_building_api }

    trait :with_provider_info do
      provider_website_url { "https://event-provider.com" }
      provider_target_audience { "Anyone interested in teaching from Sept 2021" }
      provider_organiser { "United Teaching" }
      provider_contact_email { "jim@smith.com" }
    end
  end
end
