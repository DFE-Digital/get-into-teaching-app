FactoryBot.define do
  factory :mailing_list_name, class: MailingList::Steps::Name do
    first_name { "Test" }
    sequence(:last_name) { |n| "User #{n}" }
    sequence(:email_address) { |n| "testuser#{n}@testing.education.gov.uk" }
    current_status { MailingList::Steps::Name.current_statuses.first }
  end
end
