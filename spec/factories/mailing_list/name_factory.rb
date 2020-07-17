FactoryBot.define do
  factory :mailing_list_name, class: MailingList::Steps::Name do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email) { |n| "testuser#{n}@testing.education.gov.uk" }
    describe_yourself_option_id { GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Student"] }
  end
end
