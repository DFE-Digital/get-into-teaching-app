FactoryBot.define do
  factory :event_building_factory, class: "Internal::EventBuilding" do
    id { "test" }
    venue { "test" }
    address_line1 { "test" }
    address_line2 { "test" }
    address_line3 { "test" }
    address_city { "test" }
    address_postcode { "M1 7AX" }
  end
end
