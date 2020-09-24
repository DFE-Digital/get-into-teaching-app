# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  tta_service_uri = URI.parse(ENV["TTA_SERVICE_URL"])
  google_analytcs = "www.google-analytics.com ssl.google-analytics.com www.googletagmanager.com"

  config.csp = {
    default_src: %w['none'],
    base_uri: %w['self'],
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w['self' *.youtube.com ct.pinterest.com tr.snapchat.com *.hotjar.com],
    connect_src: %W['self' #{tta_service_uri.host} #{google_analytcs} ct.pinterest.com *.hotjar.com www.facebook.com],
    font_src: %w['self' *.gov.uk fonts.gstatic.com],
    form_action: %w['self' tr.snapchat.com www.facebook.com www.gov.uk],
    frame_ancestors: %w['self'],
    frame_src: %w['self' tr.snapchat.com www.facebook.com www.youtube.com],
    img_src: %W['self' linkbam.uk *.gov.uk data: maps.gstatic.com *.googleapis.com #{google_analytcs} www.facebook.com ct.pinterest.com t.co www.facebook.com cx.atdmt.com],
    manifest_src: %w['self'],
    media_src: %w['self'],
    script_src: %W['self' 'unsafe-inline' *.googleapis.com *.gov.uk code.jquery.com #{google_analytcs} *.facebook.net *.googletagmanager.com *.hotjar.com *.pinimg.com sc-static.net static.ads-twitter.com analytics.twitter.com],
    style_src: %w['self' 'unsafe-inline' *.gov.uk *.googleapis.com],
    worker_src: %w['self'],
    upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: [ENV["SENTRY_CSP_REPORT_URI"]],
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[ws: localhost:*]
  end
end
# rubocop:enable Lint/PercentStringArray
