require "rails_helper"

RSpec.describe Chat, type: :model do
  describe "#to_h" do
    subject { described_class.new.to_h }

    before { allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/") }

    context "when the API returns an available status" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": true, \"status_age\": 123 }")
      end

      it { is_expected.to eql({ skillid: 123_456, available: true, status_age: 123 }) }
    end

    context "when the API returns an unavailable status" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": false, \"status_age\": 123 }")
      end

      it { is_expected.to eql({ skillid: 123_456, available: false, status_age: 123 }) }
    end

    context "when the API has an error" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 500, body: "error")
      end

      it { is_expected.to eql({ skillid: nil, available: false, status_age: nil }) }
    end
  end

  describe "#available" do
    subject { described_class.new.available }

    before { allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/") }

    context "when the API returns an available status" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": true, \"status_age\": 123 }")
      end

      it { is_expected.to be(true) }
    end

    context "when the API returns an unavailable status" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": false, \"status_age\": 123 }")
      end

      it { is_expected.to be(false) }
    end

    context "when the API has an error" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 500, body: "error")
      end

      it { is_expected.to be(false) }
    end
  end
end
