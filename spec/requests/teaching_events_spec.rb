require "rails_helper"

describe "teaching events", type: :request do
  describe "#index" do
    let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }
    let(:events_by_type) { group_events_by_type(events) }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type) { events_by_type }
    end

    subject do
      get events_path
      response
    end

    it { is_expected.to have_http_status(:success) }

    context "when searching" do
      subject do
        params = { postcode: Encryptor.encrypt("KY11 9YU"), distance: 20, online: false }
        get events_path(params: { teaching_events_search: params })
        response
      end

      it { is_expected.to have_http_status(:success) }
    end
  end

  describe "#show" do
    let(:event) { build(:event_api) }
    let(:readable_id) { event.readable_id }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:get_teaching_event).with(readable_id) { event }
    end

    subject(:perform_request) do
      get event_path(readable_id)
      response
    end

    it { is_expected.to have_http_status(:success) }

    context "when the event is not found" do
      let(:not_found_error) { GetIntoTeachingApiClient::ApiError.new(code: 404) }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).with(readable_id).and_raise(not_found_error)
      end

      it { is_expected.to have_http_status(:not_found) }
    end

    context "when the event is nil" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).with(readable_id).and_return(nil)
      end

      it { is_expected.to have_http_status(:not_found) }
    end

    context "when the event is not viewable" do
      let(:event) { build(:event_api, :train_to_teach_event, :past) }

      it { is_expected.to have_http_status(:gone) }
    end

    context "when the event is pending" do
      let(:event) { build(:event_api, :pending) }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe "#about_ttt_events" do
    subject do
      get about_ttt_events_path
      response
    end

    it { is_expected.to have_http_status(:success) }
  end
end
