require "rails_helper"

describe Healthcheck do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:gitsha) { "d64e925a5c70b05246e493de7b60af73e1dfa9dd" }

  shared_examples "reading git shas" do |shamethod, shafile|
    describe "##{shamethod}" do
      subject { described_class.new.send(shamethod) }

      context "when #{shafile} is set" do
        before do
          allow(File).to receive(:read).with(shafile).and_return("#{gitsha}\n")
        end

        it { is_expected.to eql gitsha }
      end

      context "when #{shafile} is missing" do
        before do
          allow(File).to receive(:read).with(shafile).and_raise Errno::ENOENT
        end

        it { is_expected.to be_nil }
      end
    end
  end

  include_examples "reading git shas", "app_sha", "/etc/get-into-teaching-app-sha"
  include_examples "reading git shas", "content_sha", "/etc/get-into-teaching-content-sha"

  describe "test_api" do
    subject { described_class.new.test_api }

    context "with working api connection" do
      it { is_expected.to be true }
    end

    context "with broken connection" do
      it "returns false" do
        VCR.use_cassette("https_/get-into-teaching-api-dev_london_cloudapps_digital/api/lookup_items/teaching_subjects_timeout") do
          is_expected.to be false
        end
      end
    end

    context "with an API error" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
          receive(:get_teaching_subjects).and_raise(GetIntoTeachingApiClient::ApiError)
      end

      it { is_expected.to be false }
    end
  end

  describe "test_postgresql" do
    subject { described_class.new.test_postgresql }

    context "with working connection" do
      before do
        allow(ApplicationRecord).to receive(:connected?).and_return(true)
      end

      it { is_expected.to be true }
    end

    context "with broken connection" do
      before do
        allow(ApplicationRecord).to receive(:connected?).and_return(false)
      end

      it { is_expected.to be false }
    end
  end

  describe "#test_redis" do
    subject { described_class.new.test_redis }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("REDIS_URL").and_return \
        "redis://localhost:6379/1"
    end

    context "with working connection" do
      before do
        allow(REDIS).to receive(:with).and_return "PONG"
      end

      it { is_expected.to be true }
    end

    context "with broken connection" do
      before do
        allow(REDIS).to receive(:with).and_raise Redis::CannotConnectError
      end

      it { is_expected.to be false }
    end

    context "with no configured connection" do
      before { allow(ENV).to receive(:[]).with("REDIS_URL").and_return nil }

      it { is_expected.to be_nil }
    end
  end

  describe "#to_h" do
    subject { described_class.new.to_h }

    it { is_expected.to include :app_sha }
    it { is_expected.to include :content_sha }
    it { is_expected.to include :api }
    it { is_expected.to include :redis }
  end

  describe "#to_json" do
    subject { JSON.parse described_class.new.to_json }

    it { is_expected.to include "app_sha" }
    it { is_expected.to include "content_sha" }
    it { is_expected.to include "api" }
    it { is_expected.to include "redis" }
  end
end
