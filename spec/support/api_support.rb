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

shared_context "with stubbed creation channel sources, services and activities" do
  before do
    stub_request(:get, "https://get-into-teaching-api-dev.london.cloudapps.digital/api/pick_list_items/contact_creation_channel/sources")
      .to_return(status: 200,
                 body: '[{"id":222750000,"value":"Apply"},{"id":222750001,"value":"ChecKin App"},{"id":222750002,"value":"Contact centre"},{"id":222750003,"value":"GIT Website"},{"id":222750004,"value":"Highfliers"},{"id":222750005,"value":"HPITT (Teach First)"},{"id":222750006,"value":"Internships"},{"id":222750007,"value":"Legacy"},{"id":222750008,"value":"On-campus"},{"id":222750009,"value":"Paid Advertising"},{"id":222750010,"value":"Paid Search"},{"id":222750011,"value":"Paid Social"},{"id":222750012,"value":"Pipeline"},{"id":222750013,"value":"School experience"},{"id":222750014,"value":"Scholarships"}]',
                 headers: { "content-type": "application/json; charset=utf-8" })

    stub_request(:get, "https://get-into-teaching-api-dev.london.cloudapps.digital/api/pick_list_items/contact_creation_channel/services")
      .to_return(status: 200,
                 body: '[{"id":222750000,"value":"Created on Apply"},{"id":222750001,"value":"Created on School experience"},{"id":222750002,"value":"Created on Scholarships"},{"id":222750003,"value":"Created on Internships"},{"id":222750004,"value":"Created on HPITT (Teach First)"},{"id":222750005,"value":"Explore Teaching Adviser Service"},{"id":222750006,"value":"Events"},{"id":222750007,"value":"Mailing list"},{"id":222750008,"value":"Paid Search"},{"id":222750009,"value":"Return to Teaching Adviser Service"},{"id":222750010,"value":"Teacher Training Adviser Service"},{"id":222750011,"value":"Created on Highfliers"}]',
                 headers: { "content-type": "application/json; charset=utf-8" })

    stub_request(:get, "https://get-into-teaching-api-dev.london.cloudapps.digital/api/pick_list_items/contact_creation_channel/activities")
      .to_return(status: 200,
                 body: '[{"id":222750000,"value":"Brand ambassador activity"},{"id":222750001,"value":"British Council"},{"id":222750002,"value":"BRFS"},{"id":222750003,"value":"BCS"},{"id":222750004,"value":"Careers event"},{"id":222750005,"value":"CTP"},{"id":222750006,"value":"Debate Mate"},{"id":222750007,"value":"Engineers Teach Physics"},{"id":222750008,"value":"Freshers fairs"},{"id":222750009,"value":"F2F"},{"id":222750010,"value":"Grad fairs"},{"id":222750011,"value":"Institute of Physics"},{"id":222750012,"value":"IMECHE"},{"id":222750013,"value":"IMA"},{"id":222750014,"value":"NTP"},{"id":222750015,"value":"Onsite activation days"},{"id":222750016,"value":"Over 18 Careers event"},{"id":222750017,"value":"Quickfire sign-up on Apply"},{"id":222750018,"value":"Refreshers fairs"},{"id":222750019,"value":"Russell Group 6"},{"id":222750020,"value":"RCS"},{"id":222750021,"value":"Student union media"},{"id":222750022,"value":"Student Rooms"},{"id":222750023,"value":"Service Leaver"},{"id":222750024,"value":"Webinar"}]',
                 headers: { "content-type": "application/json; charset=utf-8" })
  end
end
