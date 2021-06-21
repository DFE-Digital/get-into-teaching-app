FactoryBot.define do
  factory :callbacks_privacy_policy, class: "Callbacks::Steps::PrivacyPolicy" do
    accept_privacy_policy { "1" }
  end
end
