FactoryBot.define do
  factory :event_building_api, class: Hash do
    skip_create
    initialize_with { attributes.stringify_keys }

    id { SecureRandom.uuid }
    accessibleToilets { true }
    additionalFacilities { "string" }
    addressComposite { "Line 1, Line 2" }
    addressLine1 { "Line 1" }
    addressLine2 { "Line 2" }
    addressLine3 { nil }
    city { "Manchestr" }
    stateProvince { "Greater Manchester" }
    country { "United Kingdom" }
    postalCode { "MA1 1AM" }
    description { "Main Lecture Halls Building" }
    disabledAccess { true }
    disabledParking { true }
    publicTelephoneAvailable { true }
    email { "first@someone.com" }
    name { "First Contact" }
    telephone1 { "01234567890" }
    telephone2 { nil }
    telephone3 { nil }
    website { nil }
    wifiAvailable { true }
  end
end
