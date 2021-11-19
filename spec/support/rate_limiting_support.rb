shared_examples "an IP-based rate limited endpoint" do |desc, limit, period|
  describe desc do
    subject { response.status }

    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

    before do
      allow(Rack::Attack.cache).to receive(:store) { memory_store }
      freeze_time
      request_count.times { perform_request }
    end

    context "when fewer than rate limit" do
      let(:request_count) { limit - 1 }

      it { is_expected.not_to eq(429) }
    end

    context "when more than rate limit" do
      let(:request_count) { limit + 1 }

      it { is_expected.to eq(429) }

      context "when time restriction has passed" do
        it "allows another request" do
          travel period + 10.seconds
          perform_request
          expect(response.status).not_to eq(429)
        end
      end
    end
  end
end
