FactoryBot.define do
  factory :callbacks_callback, class: "Callbacks::Steps::Callback" do
    sequence(:address_telephone) { "123456789" }
    sequence(:phone_call_scheduled_at) { 1.day.from_now }
  end
end
