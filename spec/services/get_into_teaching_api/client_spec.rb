require 'rails_helper'

describe GetIntoTeachingApi::Client do
  let(:apitoken) { "123456" }
  let(:apihost) { "test.api" }
  let(:testdata) { %w(James Jennie John) }
  let(:client) { TestEndpoint.new(token: apitoken, host: apihost) }

  class TestEndpoint < GetIntoTeachingApi::Client
    def output
      response
    end

  private

    def path
      'test/path'
    end
  end

  describe 'output parsing' do
    before do
      stub_request(:get, "https://#{apihost}/test/path").to_return \
        status: :success,
        body: testdata.to_json,
        headers: {
          'Content-Type' => "application/json"
        }
    end

    subject { client.output }

    it { is_expected.to eql '["James","Jennie","John"]' }
    it "Will check JSON is parsed"
  end

  describe "error handling" do
    it "Will iterate the various error codes and check appropriate response"
  end

  describe "retry handling" do
    it "will handle a failed connection and automatically retry"
  end
end
