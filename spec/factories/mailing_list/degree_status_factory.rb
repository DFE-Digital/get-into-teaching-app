FactoryBot.define do
  factory :mailing_list_degree_status, class: "MailingList::Steps::DegreeStatus" do
    degree_status_id { OptionSet.lookup_by_key(:degree_status, :first_year) }
  end
end
