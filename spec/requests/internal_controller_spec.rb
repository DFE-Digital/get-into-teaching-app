require "rails_helper"

describe InternalController, type: :request do
  let(:publisher_username) { "publisher_username" }
  let(:publisher_password) { "publisher_password" }
  let(:author_username) { "author_username" }
  let(:author_password) { "author_password" }

  before do
    BasicAuth.class_variable_set(:@@credentials, nil)

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to receive(:search_teaching_events_grouped_by_type) { [] }

    allow(Rails.application.config.x).to receive(:http_auth) do
      "#{publisher_username}|#{publisher_password}|publisher,#{author_username}|#{author_password}|author"
    end
  end

  it "rejects unauthenticated users" do
    get internal_events_path, headers: generate_auth_headers(:bad_credentials)

    assert_response :unauthorized
  end

  it "rejects no authentication" do
    get internal_events_path

    assert_response :unauthorized
  end

  it "sets the account role of publishers" do
    get internal_events_path, headers: generate_auth_headers(:publisher)

    expect(session[:user].username).to eq(publisher_username)
    expect(session[:user].publisher?).to be true
    assert_response :success
  end

  it "sets the account role of authors" do
    get internal_events_path, headers: generate_auth_headers(:author)

    expect(session[:user].username).to eq(author_username)
    expect(session[:user].author?).to be true
    assert_response :success
  end
end
