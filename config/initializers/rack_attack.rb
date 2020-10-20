class Rack::Attack
  # Throttle /csp_reports requests by IP (5rpm)
  throttle("req/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/csp_reports"
  end
end
