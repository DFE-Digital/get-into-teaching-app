require "rails_helper"

describe InternalController do
  let(:publisher_username) { "publisher_username" }
  let(:publisher_password) { "publisher_password" }
  let(:author_username) { "author_username" }
  let(:author_password) { "author_password" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events_grouped_by_type) { [] }

    allow(Rails.application.config.x).to receive(:http_auth) do
      "#{publisher_username}|#{publisher_password}|publisher,#{author_username}|#{author_password}|author"
    end
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

    expect(session[:user].username).to eq(publisher_username)
    expect(session[:user].role).to eq("publisher")
    assert_response :success
  end

  it "should set the account role of authors" do
    get internal_events_path, headers: generate_auth_headers(:author)

    expect(session[:user].username).to eq(author_username)
    expect(session[:user].role).to eq("author")
    assert_response :success
  end

private

  def generate_auth_headers(login_type)
    case login_type
    when :publisher
      username = publisher_username
      password = publisher_password
    when :author
      username = author_username
      password = author_password
    else
      username = "bad_username"
      password = "bad_password"
    end

    basic_auth_headers(username, password)
  end
end
