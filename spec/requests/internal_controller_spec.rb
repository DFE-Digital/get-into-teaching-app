require "rails_helper"

describe Internal do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events_grouped_by_type) { [] }
  end

  it "should reject unauthenticated users" do
    get internal_events_path, headers: generate_auth_headers(:bad_credentials)

    assert_response :unauthorized
  end

  it "should reject no authentication" do
    get internal_events_path

    assert_response :unauthorized
  end

  it "should set the account role of publishers" do
    get internal_events_path, headers: generate_auth_headers(:publisher)

    assert_response :success
    expect(session[:role]).to be(:publisher)
  end

  it "should set the account role of authors" do
    get internal_events_path, headers: generate_auth_headers(:author)

    assert_response :success
    expect(session[:role]).to be(:author)
  end
end
