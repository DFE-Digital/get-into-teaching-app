FactoryBot.define do
  factory :accessibility_option_api, class: "GetIntoTeachingApiClient::PickListItem" do
    sequence(:id)
    sequence(:value) { "Accessibility option #{_1}" }
  end
end
