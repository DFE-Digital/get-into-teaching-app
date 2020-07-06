FactoryBot.define do
  factory :mailing_list_degree_stage, class: MailingList::Steps::DegreeStage do
    degree_stage { MailingList::Steps::DegreeStage.stages.first }
  end
end
