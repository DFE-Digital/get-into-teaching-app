FactoryBot.define do
  factory :events_personal_details, class: "Events::Steps::PersonalDetails" do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email) { |n| "testuser#{n}@testing.education.gov.uk" }
    accepted_policy_id { "123" }
    event_id { "def456" }
  end
end
