FactoryBot.define do
  factory :events_personalised_updates, class: Events::Steps::PersonalisedUpdates do
    degree_status_id { 1 }
    consideration_journey_stage_id { 1 }
    address_postcode { "TE57 1NG" }
    preferred_teaching_subject_id { "fd11dc24-54ee-41b7-bf46-5f7e4d8926e5" }
  end
end
