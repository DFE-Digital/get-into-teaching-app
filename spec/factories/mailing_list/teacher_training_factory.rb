FactoryBot.define do
  factory :mailing_list_teacher_training, class: "MailingList::Steps::TeacherTraining" do
    consideration_journey_stage_id { GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["It’s just an idea"] }
  end
end
