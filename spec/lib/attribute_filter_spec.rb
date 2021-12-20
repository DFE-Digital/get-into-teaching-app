require "rails_helper"
require "attribute_filter"

describe AttributeFilter, type: :helper do
  describe ".filtered_json" do
    subject { described_class.filtered_json(input) }

    let(:model) { GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidate_id: "123", address_telephone: "1234567") }
    let(:expected_json) { { "candidateId" => "123", "addressTelephone" => "[FILTERED]" }.to_json }

    context "with an object" do
      let(:input) { model }

      it { is_expected.to eq(expected_json) }
    end

    context "with a hash" do
      let(:input) { model.to_hash }

      it { is_expected.to eq(expected_json) }
    end
  end
end
