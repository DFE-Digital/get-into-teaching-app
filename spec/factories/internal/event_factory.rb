FactoryBot.define do
  factory :internal_event, class: "Internal::Event" do
    id { SecureRandom.uuid }
    readable_id { "Test" }
    reference_number { "A1234" }
    name { "Test" }
    summary { "Test" }
    description { "Test" }
    start_at { 1.day.from_now.at_midday }
    end_at { start_at + 1.hour }
  end

  trait :provider_event do
    is_online { true }
    provider_contact_email { "test@test.com" }
    provider_organiser { "Test" }
    provider_target_audience { "Test" }
    provider_website_url { "Test" }
    registration_email_link { "https://test.test/register" }
    venue_type { "" }
    building { build :event_building }
  end
end
