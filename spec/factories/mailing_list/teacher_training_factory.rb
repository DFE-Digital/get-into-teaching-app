FactoryBot.define do
  factory :mailing_list_teacher_training, class: MailingList::Steps::TeacherTraining do
    teacher_training { MailingList::Steps::TeacherTraining.statuses.first }
  end
end
