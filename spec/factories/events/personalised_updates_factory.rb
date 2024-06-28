FactoryBot.define do
  factory :events_personalised_updates, class: "Events::Steps::PersonalisedUpdates" do
    degree_status_id do
      GetIntoTeachingApiClient::PickListItemsApi.new
        .get_qualification_degree_status.first.id
    end

    consideration_journey_stage_id do
      GetIntoTeachingApiClient::PickListItemsApi.new
        .get_candidate_journey_stages.first.id
    end

    address_postcode { "TE57 1NG" }

    preferred_teaching_subject_id do
      Crm::TeachingSubject.all.first.id
    end
  end
end
