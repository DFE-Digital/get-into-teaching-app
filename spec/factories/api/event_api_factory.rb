FactoryBot.define do
  factory :event_api, class: "GetIntoTeachingApiClient::TeachingEvent" do
    id { SecureRandom.uuid }
    sequence(:readable_id, &:to_s)
    type_id { Crm::EventType.get_into_teaching_event_id }
    web_feed_id { "123" }
    status_id { Crm::EventStatus.open_id }
    sequence(:name) { |i| "Become a Teacher #{i}" }
    sequence(:description) { |i| "<b>Become a Teacher #{i} event description</b>" }
    sequence(:summary) { |i| "Become a Teacher #{i} event summary" }
    message { "An important message" }
    video_url { "https://video.com" }
    sequence(:start_at) { |i| i.weeks.from_now.change(hour: 7, minute: 30) }
    end_at { start_at + 2.hours }
    is_online { false }
    is_virtual { false }
    building { build :event_building_api }
    region_id { Crm::EventRegion.all_ids.sample }
    accessibility_options { [1, 2] }

    trait :closed do
      status_id { Crm::EventStatus.closed_id }
    end

    trait :past do
      start_at { 2.weeks.ago }
    end

    trait :with_provider_info do
      provider_website_url { "https://event-provider.com" }
      provider_target_audience { "Anyone interested in teaching from Sept 2021" }
      provider_organiser { "United Teaching" }
      provider_contact_email { "jim@smith.com" }
    end

    trait :get_into_teaching_event do
      type_id { Crm::EventType.get_into_teaching_event_id }
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
      type_id { Crm::EventType.online_event_id }
    end

    trait :school_or_university_event do
      type_id { Crm::EventType.school_or_university_event_id }
    end

    trait :no_event_type do
      type_id { nil }
    end

    trait :no_location do
      building { nil }
    end

    trait :no_accessibility_options do
      accessibility_options { [] }
    end

    trait :pending do
      status_id { Crm::EventStatus.pending_id }
    end

    trait :without_get_into_teaching_fields do
      is_virtual { nil }
      video_url { nil }
      message { nil }
      web_feed_id { nil }
    end
  end
end
