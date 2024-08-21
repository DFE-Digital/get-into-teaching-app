shared_context "with stubbed candidate create access token api" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)
  end
end

shared_context "with stubbed event add attendee api" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:add_teaching_event_attendee)
  end
end

shared_context "with stubbed mailing list add member api" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to receive(:add_mailing_list_member)
  end
end

shared_context "with stubbed book callback api" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi)
      .to receive(:book_get_into_teaching_callback)
  end
end

shared_context "with stubbed callback quotas api" do
  let(:quotas) do
    [
      GetIntoTeachingApiClient::CallbackBookingQuota.new(
        start_at: 1.week.from_now,
        end_at: 1.week.from_now + 30.minutes,
      ),
    ]
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi)
      .to receive(:get_callback_booking_quotas) { quotas }
  end
end
