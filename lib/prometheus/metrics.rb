module Prometheus
  module Metrics
    prometheus = Prometheus::Client.registry

    prometheus.counter(
      :app_requests_total,
      docstring: "A counter of requests",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :app_request_duration_ms,
      docstring: "A histogram of request durations",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :app_request_view_runtime_ms,
      docstring: "A histogram of request view runtimes",
      labels: %i[path method status],
    )

    prometheus.histogram(
      :app_render_view_ms,
      docstring: "A histogram of view rendering times",
      labels: %i[identifier],
    )

    prometheus.histogram(
      :app_render_partial_ms,
      docstring: "A histogram of partial rendering times",
      labels: %i[identifier],
    )

    prometheus.counter(
      :app_cache_read_total,
      docstring: "A counter of cache reads",
      labels: %i[key hit],
    )
  end
end
