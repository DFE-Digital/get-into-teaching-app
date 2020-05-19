describe EventsController, type: :request do
  describe "#index" do
    before { get events_path }

    subject { response }

    it { is_expected.to have_http_status :success }
    it { is_expected.to have_rendered "index" }
  end
end
