FactoryBot.define do
  factory :internal_event, class: "Internal::Event" do
    id { SecureRandom.uuid }
    readable_id { "Test" }
    name { "Test" }
    summary { "Test" }
    description { "Test" }
    is_online { true }
    start_at { DateTime.now + 1.day }
    end_at { DateTime.now + 2.days }
    provider_contact_email { "test@test.com" }
    provider_organiser { "Test" }
    provider_target_audience { "Test" }
    provider_website_url { "Test" }
    factory :building, class: "Internal::EventBuilding" do
      fieldset { "" }
      id { "" }
      venue { "" }
      address_line1 { "" }
      address_line2 { "" }
      address_line3 { "" }
      address_city { "" }
      address_postcode { "" }
    end
  end
end
