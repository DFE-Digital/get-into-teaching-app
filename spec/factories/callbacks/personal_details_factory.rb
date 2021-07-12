FactoryBot.define do
  factory :callbacks_personal_details, class: "Callbacks::Steps::PersonalDetails" do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email) { |n| "testuser#{n}@testing.education.gov.uk" }
  end
end
