require "rails_helper"

describe InternalController, type: :request do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events).and_return([])

    allow_basic_auth_users([
      { username: "publisher", password: "password1", role: "publisher" },
      { username: "author", password: "password2", role: "author" },
    ])
  end

  it "rejects unauthenticated users" do
    get internal_events_path, headers: basic_auth_headers("publisher", "wrong-password")

    assert_response :unauthorized
  end

  it "rejects no authentication" do
    get internal_events_path

    assert_response :unauthorized
  end

  it "sets the account role of publishers" do
    get internal_events_path, headers: basic_auth_headers("publisher", "password1")

    expect(session[:user].username).to eq("publisher")
    expect(session[:user].publisher?).to be true
    assert_response :success
  end

  it "sets the account role of authors" do
    get internal_events_path, headers: basic_auth_headers("author", "password2")

    expect(session[:user].username).to eq("author")
    expect(session[:user].author?).to be true
    assert_response :success
  end
end
