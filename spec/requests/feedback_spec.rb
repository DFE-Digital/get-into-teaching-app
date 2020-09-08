require "rails_helper"

describe "POST /feedback/page_helpful" do
  let(:registry) { Prometheus::Client.registry }
  let(:metric) { registry.get(:page_helpful) }

  it "increments the :page_helpful metric" do
    params = { url: "http://test.com/test", answer: "yes" }
    expect(metric).to receive(:increment).with(labels: params).once
    post page_helpful_feedback_path, params: { page_helpful: params }
    expect(response).to have_http_status(:success)
  end

  it "returns 400 bad request if answer is not yes/no" do
    params = { url: "http://test.com/test", answer: "maybe" }
    expect(metric).to_not receive(:increment)
    post page_helpful_feedback_path, params: { page_helpful: params }
    expect(response).to have_http_status(:bad_request)
  end

  it "returns 400 bad request if url is invalid" do
    params = { url: "not-a-url", answer: "yes" }
    expect(metric).to_not receive(:increment)
    post page_helpful_feedback_path, params: { page_helpful: params }
    expect(response).to have_http_status(:bad_request)
  end
end
