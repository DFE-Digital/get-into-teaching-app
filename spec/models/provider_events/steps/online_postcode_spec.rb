require "rails_helper"

RSpec.describe ProviderEvents::Steps::OnlinePostcode do
  before do
    allow(Faraday).to receive(:get).with(start_with("https://api.postcodes.io/postcodes/")).and_return(response)
  end

  let(:response) do
    instance_double(
      Faraday::Response,
      success?: true,
      body: {
        result: {
          admin_district: "My Toon",
          region: "Somewheresville",
        },
      }.to_json,
    )
  end

  include_context "with wizard step"

  it_behaves_like "a with wizard step"
  it_behaves_like "a normalised and validated postcode", :online_postcode, "Enter a full UK postcode"

  it { is_expected.to validate_presence_of :online_postcode }
  it { is_expected.to validate_length_of(:online_postcode).is_at_most(10) }

  describe "online_district_or_region" do
    subject { instance.online_district_or_region }

    before do
      instance.online_postcode = online_postcode
      instance.validate
    end

    context "when there is no postcode" do
      let(:online_postcode) { nil }

      it { is_expected.to be_nil }
    end

    context "when there is an invalid postcode" do
      let(:online_postcode) { "FOO FOO" }

      it { is_expected.to be_nil }
    end

    context "when there is a valid postcode" do
      let(:online_postcode) { "WC1A 1AA" }

      it { is_expected.to eql("My Toon") }
    end
  end

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:event_type) { instance_double(ProviderEvents::Steps::EventType, in_person?: in_person) }
    end

    context "when in-person" do
      let(:in_person) { true }

      it { is_expected.to be_skipped }
    end

    context "when not in-person" do
      let(:in_person) { false }

      it { is_expected.not_to be_skipped }
    end
  end

  describe "reviewable_answers" do
    subject { instance.reviewable_answers }

    before do
      allow(instance).to receive(:other_step).with(:event_type) { instance_double(ProviderEvents::Steps::EventType, online?: true) }
      instance.online_postcode = online_postcode
      instance.validate
    end

    context "when there is no postcode" do
      let(:online_postcode) { nil }

      it { is_expected.to eql({ "online_postcode" => nil }) }
    end

    context "when there is an invalid postcode" do
      let(:online_postcode) { "FOO FOO" }

      it { is_expected.to eql({ "online_postcode" => "FOO FOO" }) }
    end

    context "when there is a valid postcode" do
      let(:online_postcode) { "WC1A 1AA" }

      it { is_expected.to eql({ "online_postcode" => "WC1A 1AA (My Toon)" }) }
    end
  end
end
