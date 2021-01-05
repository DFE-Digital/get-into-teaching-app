FactoryBot.define do
  factory :mailing_list_subject, class: "MailingList::Steps::Subject" do
    preferred_teaching_subject_id { GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["Physics"] }
  end
end
