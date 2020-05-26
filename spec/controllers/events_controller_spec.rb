describe EventsController, type: :request do
  describe "#index" do
    let(:events) do
      [
        { eventName: "First", description: "first", startDate: "2020-05-20" },
        { eventName: "Second", description: "second", startDate: "2020-05-21" },
      ]
    end

    before do
      allow_any_instance_of(GetIntoTeachingApi::UpcomingEvents).to \
        receive(:data).and_return events
    end

    subject { get(events_path); response }

    it { is_expected.to have_http_status :success }
    it { is_expected.to have_rendered "index" }
  end

  describe "#search" do
    let(:search_key) { Events::Search.model_name.param_key }
    let(:search_path) { search_events_path(search_key: search_params) }
    subject { get(search_path); response }

    context "with valid search params" do
      let(:search_params) { attributes_for :events_search }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_rendered "index" }
    end

    context "with invalid search params" do
      let(:search_params) { {} }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_rendered "index" }
    end
  end
end
