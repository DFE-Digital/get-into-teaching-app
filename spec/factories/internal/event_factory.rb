FactoryBot.define do
  factory :internal_event, class: "Internal::Event" do
    id { SecureRandom.uuid }
    readable_id { "Test" }
    name { "Test" }
    summary { "Test" }
    description { "Test" }
    start_at { DateTime.now + 1.day }
    end_at { DateTime.now + 2.days }
  end

  trait :online_event do
    scribble_id { "/scribble/id/1234" }
  end

  trait :provider_event do
    is_online { true }
    provider_contact_email { "test@test.com" }
    provider_organiser { "Test" }
    provider_target_audience { "Test" }
    provider_website_url { "Test" }
    venue_type { "" }
    building { build :event_building }
  end
end
