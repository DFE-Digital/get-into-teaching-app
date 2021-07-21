FactoryBot.define do
  factory :event_building_api, class: "GetIntoTeachingApiClient::TeachingEventBuilding" do
    id { SecureRandom.uuid }
    venue { "Albert Hall" }
    address_line1 { "Line 1" }
    address_line2 { "Line 2" }
    address_line3 { nil }
    address_city { "Manchester" }
    address_postcode { "MA1 1AM" }
    image_url { "http://example.com/image.png" }
  end
end
