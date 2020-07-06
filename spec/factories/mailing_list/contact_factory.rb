FactoryBot.define do
  factory :mailing_list_contact, class: MailingList::Steps::Contact do
    phone_number { "01234567890" }
    accept_privacy_policy { "1" }
  end
end
