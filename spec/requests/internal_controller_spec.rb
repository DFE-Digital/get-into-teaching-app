require "rails_helper"

describe Internal do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events_grouped_by_type) { [] }
  end

  it "should reject unauthenticated users" do
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(
      "wrong",
      "wrong",
    )

    get internal_events_path, headers: { "HTTP_AUTHORIZATION" => authorization }

    assert_response :unauthorized
  end

  it "should reject no authentication" do
    get internal_events_path

    assert_response :unauthorized
  end

  it "should set the account role of publishers" do
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV["PUBLISHER_USERNAME"],
      ENV["PUBLISHER_PASSWORD"],
    )

    get internal_events_path, headers: { "HTTP_AUTHORIZATION" => authorization }

    assert_response 200
    expect(session[:role]).to be(:publisher)
  end

  it "should set the account role of authors" do
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV["AUTHOR_USERNAME"],
      ENV["AUTHOR_PASSWORD"],
    )

    get internal_events_path, headers: { "HTTP_AUTHORIZATION" => authorization }

    assert_response 200
    expect(session[:role]).to be(:author)
  end
end
