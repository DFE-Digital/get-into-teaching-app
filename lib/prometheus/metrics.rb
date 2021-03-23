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

    prometheus.counter(
      :app_csp_violations_total,
      docstring: "A counter of CSP violations",
      labels: %i[blocked_uri document_uri violated_directive],
    )

    prometheus.gauge(
      :app_page_speed_score_performance,
      docstring: "Google page speed scores (performance)",
      labels: %i[strategy path],
    )

    prometheus.gauge(
      :app_page_speed_score_accessibility,
      docstring: "Google page speed scores (accessibility)",
      labels: %i[strategy path],
    )

    prometheus.gauge(
      :app_page_speed_score_seo,
      docstring: "Google page speed scores (seo)",
      labels: %i[strategy path],
    )
  end
end
