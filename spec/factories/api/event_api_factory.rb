FactoryBot.define do
  factory :event_api, class: "GetIntoTeachingApiClient::TeachingEvent" do
    id { SecureRandom.uuid }
    sequence(:readable_id, &:to_s)
    type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"] }
    status_id { GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"] }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "<b>Become a Teacher #{i} event description</b>" }
    sequence(:summary) { |i| "Become a Teacher #{i} event summary" }
    sequence(:start_at) { |i| i.weeks.from_now.change(hour: 7, minute: 30) }
    end_at { start_at + 2.hours }
    is_online { false }
    building { build :event_building_api }

    trait :optional do
      web_feed_id { "123" }
      message { "An important message" }
      video_url { "https://video.com" }
      is_virtual { false }
    end

    trait :closed do
      status_id { GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"] }
    end

    trait :with_provider_info do
      provider_website_url { "https://event-provider.com" }
      provider_target_audience { "Anyone interested in teaching from Sept 2021" }
      provider_organiser { "United Teaching" }
      provider_contact_email { "jim@smith.com" }
    end

    trait :train_to_teach_event do
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"] }
    end

    trait :virtual do
      is_online { true }
      is_virtual { true }
    end

    trait :online do
      is_online { true }
      is_virtual { false }
      building { nil }
    end

    trait :online_event do
      online
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"] }
    end

    trait :school_or_university_event do
      type_id { GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"] }
    end

    trait :no_event_type do
      type_id { nil }
    end

    trait :no_location do
      building { nil }
    end
  end
end
