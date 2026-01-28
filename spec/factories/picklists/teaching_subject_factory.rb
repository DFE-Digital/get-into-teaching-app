FactoryBot.define do
  factory :teaching_subject, class: "GetIntoTeachingApiClient::TeachingSubject" do
    transient do
      subject_key { :physics }
    end

    id { Crm::TeachingSubject.lookup_by_key(subject_key) }
    value { "Teaching Subject #{subject_key}" }
  end
end
