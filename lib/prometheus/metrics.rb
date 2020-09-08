module Prometheus
  module Metrics
    prometheus = Prometheus::Client.registry

    prometheus.counter(
      :page_helpful,
      docstring: "A counter of 'is this page helpful' responses",
      labels: %i[url answer],
    )
  end
end
