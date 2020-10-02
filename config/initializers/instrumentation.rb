ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  payload = event.payload.symbolize_keys.reject { |_, v| v.nil? }

  prometheus = Prometheus::Client.registry

  labels = { path: nil, method: nil, status: nil }
  labels.merge!(payload.slice(*labels.keys))

  metric = prometheus.get(:requests_total)
  metric.increment(labels: labels)

  metric = prometheus.get(:request_duration_ms)
  metric.observe(event.duration, labels: labels)

  if payload.key?(:view_runtime)
    metric = prometheus.get(:request_view_runtime_ms)
    metric.observe(payload[:view_runtime], labels: labels)
  end
end

ActiveSupport::Notifications.subscribe "render_template.action_view" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { identifier: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  metric = prometheus.get(:render_view_ms)
  metric.observe(event.duration, labels: labels)
end

ActiveSupport::Notifications.subscribe "render_partial.action_view" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { identifier: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  metric = prometheus.get(:render_partial_ms)
  metric.observe(event.duration, labels: labels)
end

ActiveSupport::Notifications.subscribe "cache_read.active_support" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  prometheus = Prometheus::Client.registry

  labels = { key: nil, hit: nil }
  labels.merge!(event.payload.symbolize_keys.slice(*labels.keys))

  metric = prometheus.get(:cache_read_total)
  metric.increment(labels: labels)
end
