if ENV["ENABLE_DEMOVIEWS"].to_s.in? %w[yes true 1]
  ActionController::Base.append_view_path Rails.root.join("app/demoviews")
end
