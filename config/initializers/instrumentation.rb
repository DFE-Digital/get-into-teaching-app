ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload.symbolize_keys.reject { |_, v| v.nil? }
  prometheus = Prometheus::Client.registry

  labels = { path: nil, method: nil, status: nil }
  labels.merge!(payload.slice(*labels.keys))

  labels[:path] = labels[:path].split("?").first if labels[:path]

  metric = prometheus.get(:app_requests_total)
  metric.increment(labels: labels)

  metric = prometheus.get(:app_request_duration_ms)
  metric.observe(event.duration, labels: labels)

  if payload.key?(:view_runtime)
    metric = prometheus.get(:app_request_view_runtime_ms)
    metric.observe(payload[:view_runtime], labels: labels)
  end
end

ActiveSupport::Notifications.subscribe "render_template.action_view" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { identifier: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  labels[:identifier] = labels[:identifier].split("/app/views/").last if labels[:identifier]

  metric = prometheus.get(:app_render_view_ms)
  metric.observe(event.duration, labels: labels)
end

ActiveSupport::Notifications.subscribe "render_partial.action_view" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { identifier: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  labels[:identifier] = labels[:identifier].split("/app/views/").last if labels[:identifier]

  metric = prometheus.get(:app_render_partial_ms)
  metric.observe(event.duration, labels: labels)
end

ActiveSupport::Notifications.subscribe "cache_read.active_support" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { key: nil, hit: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  metric = prometheus.get(:app_cache_read_total)
  metric.increment(labels: labels)
end

ActiveSupport::Notifications.subscribe "app.csp_violation" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  report = event.payload.transform_keys(&:underscore).symbolize_keys

  prometheus = Prometheus::Client.registry

  labels = { blocked_uri: nil, document_uri: nil, violated_directive: nil }
  labels.merge!(report.slice(*labels.keys))

  labels[:violated_directive] = labels[:violated_directive].split.first if labels[:violated_directive]
  labels[:blocked_uri] = labels[:blocked_uri].split("?").first if labels[:blocked_uri]

  if labels[:document_uri]
    document_uri = URI.parse(labels[:document_uri])
    labels[:document_uri] = document_uri.path
  end

  metric = prometheus.get(:app_csp_violations_total)
  metric.increment(labels: labels)
end

ActiveSupport::Notifications.subscribe "app.client_metric" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  metric_details = event.payload.deep_symbolize_keys

  fail(ArgumentError, "attempted to increment non-client metric") unless metric_details[:key].start_with?("app_client_")

  prometheus = Prometheus::Client.registry

  metric = prometheus.get(metric_details[:key])
  metric.increment(labels: metric_details[:labels])
end
