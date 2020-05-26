require "rails_helper"

describe GetIntoTeachingApi::Base do
  let(:apitoken) { "123456" }
  let(:apihost) { "https://test.api" }
  let(:testdata) { %w(James Jennie John) }
  let(:client) { TestEndpoint.new(token: apitoken, endpoint: apihost) }
  let(:endpoint) { "#{apihost}/test/path" }
  let(:response_headers) { { "Content-Type" => "application/json" } }

  class TestEndpoint < GetIntoTeachingApi::Base
    def output
      data
    end

    def status
      response.status
    end

  private

    def path
      "test/path"
    end
  end

  describe "output parsing" do
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
    subject { client.output }

    {
      400 => Faraday::ClientError,
      404 => Faraday::ResourceNotFound,
      405 => Faraday::ClientError,
      500 => Faraday::ServerError,
      502 => Faraday::ServerError,
      503 => Faraday::ServerError,
    }.each do |code, error|
      context code.to_s do
        before do
          stub_request(:get, endpoint).to_return \
            status: code,
            body: "",
            headers: response_headers
        end

        it "should raise a #{error} error" do
          expect { subject }.to raise_error(error)
        end
      end
    end
  end

  describe "retry handling" do
    subject { client.output }

    context "first timeout" do
      before do
        stub_request(:get, endpoint)
          .to_timeout.then
          .to_return \
            status: 200,
            body: testdata.to_json,
            headers: response_headers
      end

      it { is_expected.to eql testdata }
    end

    context "second timeout" do
      before do
        stub_request(:get, endpoint)
          .to_timeout.then
          .to_timeout
      end

      it "will raise an error" do
        expect { subject }.to raise_exception Faraday::ConnectionFailed
      end
    end
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
