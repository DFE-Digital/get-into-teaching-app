FactoryBot.define do
  factory :mailing_list_subject, class: MailingList::Steps::Subject do
    subject { MailingList::Steps::Subject.subjects.first }
  end
end
