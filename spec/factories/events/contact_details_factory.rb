FactoryBot.define do
  factory :events_contact_details, class: "Events::Steps::ContactDetails" do
    address_telephone { "0123456789" }
  end
end
