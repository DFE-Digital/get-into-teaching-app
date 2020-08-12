FactoryBot.define do
  factory :event_building_api, class: GetIntoTeachingApiClient::TeachingEventBuilding do
    id { SecureRandom.uuid }
    address_line1 { "Line 1" }
    address_line2 { "Line 2" }
    address_line3 { nil }
    address_city { "Manchestr" }
    address_postcode { "MA1 1AM" }
  end
end
