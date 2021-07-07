# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  tta_service_hosts = []
  tta_service_hosts << URI.parse(ENV["TTA_SERVICE_URL"]).host if ENV["TTA_SERVICE_URL"].present?
  google_analytics = %w[www.google-analytics.com ssl.google-analytics.com *.googletagmanager.com tagmanager.google.com *.googleusercontent.com *.gstatic.com s.ytimg.com *.google.co.uk adservice.google.com *google.com.sa *.google.com.sa https://www.googleadservices.com https://www.google.com https://googleads.g.doubleclick.net]
  lid_pixels = %w[pixelg.adswizz.com tracking.audio.thisisdax.com]

  config.csp = {
    default_src: %w['none'],
    base_uri: %w['self'],
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    child_src: %w['self' *.youtube.com ct.pinterest.com tr.snapchat.com *.hotjar.com],
    connect_src: %w['self' ct.pinterest.com *.hotjar.com vc.hotjar.io wss://*.hotjar.com www.facebook.com *.visualwebsiteoptimizer.com stats.g.doubleclick.net] + google_analytics + tta_service_hosts,
    font_src: %w['self' *.gov.uk fonts.gstatic.com],
    form_action: %w['self' tr.snapchat.com www.facebook.com www.gov.uk dev.visualwebsiteoptimizer.com],
    frame_ancestors: %w['self'],
    frame_src: %w['self' embed.scribblelive.com tr.snapchat.com www.facebook.com www.youtube.com www.youtube-nocookie.com *.hotjar.com *.doubleclick.net dev.visualwebsiteoptimizer.com],
    img_src: %w['self' linkbam.uk *.gov.uk data: *.googleapis.com www.facebook.com ct.pinterest.com t.co www.facebook.com cx.atdmt.com *.visualwebsiteoptimizer.com *.doubleclick.net i.ytimg.com adservice.google.com adservice.google.co.uk] + google_analytics + lid_pixels,
    manifest_src: %w['self'],
    media_src: %w['self'],
    script_src: %w['self' 'unsafe-inline' 'unsafe-eval' embed.scribblelive.com *.googleapis.com *.gov.uk code.jquery.com *.facebook.net *.hotjar.com *.pinimg.com sc-static.net static.ads-twitter.com analytics.twitter.com *.youtube.com *.visualwebsiteoptimizer.com] + google_analytics,
    style_src: %w['self' 'unsafe-inline' *.gov.uk *.googleapis.com] + google_analytics,
    worker_src: %w['self' *.visualwebsiteoptimizer.com blob:],
    upgrade_insecure_requests: !Rails.env.development?, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w[/csp_reports],
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[ws: localhost:*]
  end
end
# rubocop:enable Lint/PercentStringArray
