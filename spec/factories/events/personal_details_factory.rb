FactoryBot.define do
  factory :events_personal_details, class: "Events::Steps::PersonalDetails" do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email) { |n| "testuser#{n}@testing.education.gov.uk" }
    accepted_policy_id { "4872c8ed-0229-f111-8342-7c1e5285e3ab" }
    event_id { "def456" }
  end
end
