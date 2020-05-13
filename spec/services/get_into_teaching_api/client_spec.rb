require 'rails_helper'

describe GetIntoTeachingApi::Client do
  let(:apitoken) { "123456" }
  let(:apihost) { "test.api" }
  let(:testdata) { %w(James Jennie John) }
  let(:client) { TestEndpoint.new(token: apitoken, host: apihost) }
  let(:endpoint) { "https://#{apihost}/test/path" }
  let(:response_headers) { { "Content-Type" => "application/json" } }

  class TestEndpoint < GetIntoTeachingApi::Client
    def output
      data
    end

    def status
      response.status
    end

  private

    def path
      'test/path'
    end
  end

  describe 'output parsing' do
    before do
      stub_request(:get, endpoint).to_return \
        status: 200,
        headers: response_headers,
        body: testdata.to_json
    end

    subject { client.output }
    it { is_expected.to eql testdata }
  end

  describe "error handling" do
    it "Will iterate the various error codes and check appropriate response"
  end

  describe "retry handling" do
    it "will handle a failed connection and automatically retry"
  end

  describe "authentication" do
    let(:auth) { { "Authorization" => "Bearer 123456" } }

    context "With valid token" do
      before do
        stub_request(:get, endpoint).with(headers: auth).to_return \
          status: 200,
          headers: response_headers,
          body: testdata.to_json
      end

      subject { client.status }

      it("will succeed") { is_expected.to be 200 }
    end

    context "With invalid token" do
      before do
        stub_request(:get, endpoint).with(headers: auth).to_return \
          status: 401,
          headers: response_headers,
          body: ""
      end

      it "will fail" do
        expect { client.status }.to raise_exception Faraday::UnauthorizedError
      end
    end
  end
end
