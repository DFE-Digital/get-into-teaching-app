shared_context "when requesting a page with the Get Into Teaching events badge" do
  before do
    # Needed for the JS-enabled specs; the GiT event badge
    # is shown on every page via JS.
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type)
        .and_return({})
  end
end
