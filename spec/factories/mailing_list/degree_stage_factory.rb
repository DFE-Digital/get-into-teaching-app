FactoryBot.define do
  factory :mailing_list_degree_stage, class: MailingList::Steps::DegreeStage do
    degree_status_id { GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS["First year"] }
  end
end
