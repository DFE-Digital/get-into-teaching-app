FactoryBot.define do
  factory :mailing_list_teacher_training, class: "MailingList::Steps::TeacherTraining" do
    consideration_journey_stage_id { OptionSet.lookup_by_key(:consideration_journey_stage, :it_s_just_an_idea) }
  end
end
