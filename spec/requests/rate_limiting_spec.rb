require "rails_helper"

describe "Rate limiting" do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  before { allow(Rack::Attack.cache).to receive(:store) { memory_store } }

  describe "POST /csp_reports" do
    let(:limit) { 1 }
    let(:ip) { "1.2.3.4" }

    before { limit.times { post csp_reports_path, params: {}.to_json, headers: { "REMOTE_ADDR" => ip } } }

    subject { response.status }

    context "when fewer than rate limit" do
      let(:limit) { 4 }

      it { is_expected.to_not eq(429) }
    end

    context "when more than rate limit" do
      let(:limit) { 6 }

      it do
        is_expected.to eq(429)
      end

      context "when time restriction has passed" do
        it "allows another request" do
          travel 1.minute
          post csp_reports_path, params: {}.to_json, headers: { "REMOTE_ADDR" => ip }
          expect(response.status).to_not eq(429)
        end
      end
    end
  end
end
