class FeedbackController < ApplicationController
  def page_helpful
    prometheus = Prometheus::Client.registry
    counter = prometheus.get(:page_helpful)
    page_helpful = Feedback::PageHelpful.new(page_helpful_params)

    head(:bad_request) && return if page_helpful.invalid?

    labels = page_helpful.attributes
      .slice("url", "answer")
      .transform_keys(&:to_sym)
    counter.increment(labels: labels)
    head :ok
  end

private

  def page_helpful_params
    params.require(:page_helpful).permit(:url, :answer)
  end
end
