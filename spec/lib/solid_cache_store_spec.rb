require "rails_helper"

RSpec.describe "Solid Cache" do # rubocop:disable RSpec/DescribeClass
  subject(:store) { ActiveSupport::Cache.lookup_store(:solid_cache_store, namespace: "session-spec") }

  after { SolidCache::Entry.delete_all }

  it "stores values larger than 4KB in the primary database" do
    session = { "sign_up" => { "notes" => "x" * 10_000 } }

    store.write("session-id", session, expires_in: 1.day)

    expect(store.read("session-id")).to eq(session)
    expect(SolidCache::Entry.connection).to eq(ApplicationRecord.connection)
  end

  it "does not return expired entries" do
    store.write("session-id", "data", expires_in: 1.minute)

    travel_to(2.minutes.from_now) { expect(store.read("session-id")).to be_nil }
  end

  describe "as the session store" do
    let(:app) do
      inner = lambda do |env|
        session = env["rack.session"]
        session[:data] ||= "x" * 10_000
        [200, {}, [session[:data].size.to_s]]
      end
      sessions = ActionDispatch::Session::CacheStore.new(inner, key: "_dfe_session", cache: store, expire_after: 1.day)
      ActionDispatch::Cookies.new(sessions)
    end
    let(:env) { Rails.application.env_config.merge("HTTPS" => "on") }

    it "keeps sessions over 4KB server side and sends only an id cookie" do
      first = Rack::MockRequest.new(app).get("/", env)
      cookie = first["Set-Cookie"][/_dfe_session=[^;]+/]

      expect(cookie.bytesize).to be < 200
      expect(SolidCache::Entry.count).to eq(1)

      second = Rack::MockRequest.new(app).get("/", env.merge("HTTP_COOKIE" => cookie))
      expect(second.body).to eq("10000")
    end
  end
end
