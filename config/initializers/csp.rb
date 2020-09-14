# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]
  config.csp = {
    default_src: %w['none'],
    base_uri: %w['self'],
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w['self' *.youtube.com],
    connect_src: %w['self'],
    font_src: %w['self'],
    form_action: %w['self'],
    frame_ancestors: %w['none'],
    img_src: %w['self'],
    manifest_src: %w['self'],
    media_src: %w['self'],
    script_src: %w['self' *.facebook.net *.googletagmanager.com *.hotjar.com *.pinimg.com *.sc-static.net],
    style_src: %w['self' 'unsafe-inline'],
    worker_src: %w['self'],
    upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
  }
end
# rubocop:enable Lint/PercentStringArray
