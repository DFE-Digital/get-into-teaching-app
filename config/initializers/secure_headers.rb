# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  tta_service_uri = URI.parse(ENV["TTA_SERVICE_URL"])

  config.csp = {
    default_src: %w['none'],
    base_uri: %w['self'],
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w['self' *.youtube.com],
    connect_src: %W['self' #{tta_service_uri.host}],
    font_src: %w['self' *.gov.uk fonts.gstatic.com],
    form_action: %w['self'],
    frame_ancestors: %w['none'],
    img_src: %w['self' *.gov.uk data: maps.gstatic.com *.googleapis.com],
    manifest_src: %w['self'],
    media_src: %w['self'],
    script_src: %w['self' 'unsafe-inline' *.googleapis.com *.gov.uk code.jquery.com *.google-analytics.com *.facebook.net *.googletagmanager.com *.hotjar.com *.pinimg.com *.sc-static.net],
    style_src: %w['self' 'unsafe-inline' *.gov.uk *.googleapis.com],
    worker_src: %w['self'],
    upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: [ENV["SENTRY_CSP_REPORT_URI"]],
  }
end
# rubocop:enable Lint/PercentStringArray
