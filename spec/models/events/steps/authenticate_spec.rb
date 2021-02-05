require "rails_helper"

describe Events::Steps::Authenticate do
  include_context "wizard step"

  it { is_expected.to be_kind_of(::Wizard::Steps::Authenticate) }

  it "calls exchange_access_token_for_teaching_event_add_attendee on valid save" do
    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new
    expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).and_return(response)
    subject.assign_attributes(attributes_for(:authenticate))
    subject.save
  end
end
