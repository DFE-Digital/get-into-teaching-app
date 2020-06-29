require "rails_helper"

describe Healthcheck do
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

        it { is_expected.to eql nil }
      end
    end
  end

  include_examples "reading git shas", "app_sha", "/etc/get-into-teaching-app-sha"
  include_examples "reading git shas", "content_sha", "/etc/get-into-teaching-content-sha"

  describe "#to_h" do
    subject { described_class.new.to_h }
    it { is_expected.to include :app_sha }
    it { is_expected.to include :content_sha }
  end

  describe "#to_json" do
    subject { JSON.parse described_class.new.to_json }
    it { is_expected.to include "app_sha" }
    it { is_expected.to include "content_sha" }
  end
end
