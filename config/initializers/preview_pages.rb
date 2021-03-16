if ENV["PREVIEW_PAGES"].to_s.in? %w[yes true 1]
  ActionController::Base.append_view_path Rails.root.join("app/preview_pages")
end
