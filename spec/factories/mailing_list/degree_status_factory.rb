FactoryBot.define do
  factory :mailing_list_degree_status, class: MailingList::Steps::DegreeStatus do
    degree_status_id { GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["First year"] }
  end
end
