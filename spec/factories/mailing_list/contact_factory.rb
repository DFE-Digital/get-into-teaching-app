FactoryBot.define do
  factory :mailing_list_contact, class: MailingList::Steps::Contact do
    accept_privacy_policy { "1" }
  end
end
