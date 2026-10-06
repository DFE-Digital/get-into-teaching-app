require "rails_helper"
require "postcodes_io"

RSpec.describe PostcodesIO do
  describe "#district_or_region" do
    subject(:district_or_region) do
      described_class.new(postcode).district_or_region
    end

    let(:postcode) { " ab1 2cd " }
    let(:url) { "https://api.postcodes.io/postcodes/AB1%202CD" }
    let(:success?) { true }
    let(:body) { { result: {} }.to_json }

    let(:response) do
      instance_double(
        Faraday::Response,
        success?: success?,
        body: body,
      )
    end

    before do
      allow(Faraday).to receive(:get).with(url).and_return(response)
    end

    context "when the API returns an admin district" do
      let(:body) do
        {
          result: {
            admin_district: "My Toon",
            region: "Scotland",
          },
        }.to_json
      end

      it "returns the admin district" do
        expect(district_or_region).to eq("My Toon")
      end

      it "normalises and URL-encodes the postcode" do
        district_or_region

        expect(Faraday).to have_received(:get).with(url)
      end
    end

    context "when the API has no admin district but has a region" do
      let(:body) do
        {
          result: {
            admin_district: nil,
            region: "Scotland",
          },
        }.to_json
      end

      it "returns the region" do
        expect(district_or_region).to eq("Scotland")
      end
    end

    context "when the API has neither a district nor region" do
      it "returns the postcode area" do
        expect(district_or_region).to be_nil
      end
    end

    context "when the API response is unsuccessful" do
      let(:success?) { false }

      it "returns the postcode area" do
        expect(district_or_region).to be_nil
      end
    end

    context "when the API connection fails" do
      before do
        allow(Faraday)
          .to receive(:get)
                .with(url)
                .and_raise(Faraday::ConnectionFailed, "Connection failed")
      end

      it "returns the postcode area" do
        expect(district_or_region).to be_nil
      end
    end

    context "when the API returns invalid JSON" do
      let(:body) { "not valid JSON" }

      it "returns the postcode area" do
        expect(district_or_region).to be_nil
      end
    end

    context "when the API response has no result key" do
      let(:body) { {}.to_json }

      it "returns the postcode area" do
        expect(district_or_region).to be_nil
      end
    end
  end
end
