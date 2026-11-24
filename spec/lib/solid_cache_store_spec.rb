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
end
