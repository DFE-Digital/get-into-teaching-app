shared_examples "an IP-based rate limited endpoint" do |desc, limit, period|
  describe desc do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

    before do
      allow(Rack::Attack.cache).to receive(:store) { memory_store }
      request_count.times { perform_request }
    end

    subject { response.status }

    context "when fewer than rate limit" do
      let(:request_count) { limit - 1 }

      it { is_expected.to_not eq(429) }
    end

    context "when more than rate limit" do
      let(:request_count) { limit + 1 }

      it { is_expected.to eq(429) }

      context "when time restriction has passed" do
        it "allows another request" do
          travel period + 1.second
          perform_request
          expect(response.status).to_not eq(429)
        end
      end
    end
  end
end
