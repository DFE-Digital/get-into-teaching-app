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

  lid_pixels = %w[pixelg.adswizz.com tracking.audio.thisisdax.com]

  google_analytics = %w[
    *.google-analytics.com
    *.googleadservices.com
    *.googlesyndication.com
    *.googletagmanager.com
    *.googleusercontent.com
    *.gstatic.com
    *.googleanalytics.com
    https://googleads.g.doubleclick.net
    https://ssl.google-analytics.com
    https://tagmanager.google.com
    https://www.googletagmanager.com/gtm.js
  ]

  google_supported   = %w[*.google.com *.google.co.uk]
  google_adservice   = %w[adservice.google.com adservice.google.co.uk]
  google_doubleclick = %w[*.doubleclick.net *.googleads.g.doubleclick.net *.ad.doubleclick.net *.fls.doubleclick.net stats.g.doubleclick.net]
  google_apis        = %w[*.googleapis.com googleapis.com https://fonts.googleapis.com]

  optimize    = %w[optimize.google.com www.googleoptimize.com]
  zendesk     = %w[static.zdassets.com https://*.zopim.com wss://*.zopim.com dfesupport-tpuk.zendesk.com ekr.zdassets.com]
  facebook    = %w[*.facebook.com *.facebook.net *.connect.facebook.net]
  govuk       = %w[*.gov.uk www.gov.uk]
  hotjar      = %w[*.hotjar.com vc.hotjar.io wss://*.hotjar.com]
  jquery      = %w[code.jquery.com]
  pinterest   = %w[*.pinterest.com *.pinterest.co.uk *.pinimg.com]
  scribble    = %w[embed.scribblelive.com]
  snapchat    = %w[*.snapchat.com sc-static.net]
  twitter     = %w[t.co *.twitter.com static.ads-twitter.com analytics.twitter.com]
  youtube     = %w[*.youtube.com *.youtube-nocookie.com i.ytimg.com www.youtube.com www.youtube-nocookie.com]
  sentry      = %w[*.ingest.sentry.io]
  gtm_server  = %w[get-into-teaching-staging-gtm.nw.r.appspot.com analytics.getintoteaching.education.gov.uk]
  reddit      = %w[www.redditstatic.com alb.reddit.com]

  quoted_unsafe_inline = ["'unsafe-inline'"]
  quoted_unsafe_eval   = ["'unsafe-eval'"]
  data                 = ["data:"]
  blob                 = ["blob:"]

  config.csp = {
    block_all_mixed_content: true,
    upgrade_insecure_requests: !Rails.env.development?, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w[/csp_reports],

    default_src: %w['none'],
    base_uri: ["'self'"],
    child_src: ["'self'"].concat(youtube, pinterest, snapchat, hotjar),
    connect_src: ["'self'"].concat(google_apis, pinterest, hotjar, google_analytics, google_supported, google_doubleclick, facebook, tta_service_hosts, zendesk, snapchat, sentry, gtm_server),
    font_src: ["'self'"].concat(govuk, data, %w[fonts.gstatic.com]),
    form_action: ["'self'"].concat(snapchat, facebook, govuk),
    frame_src: ["'self'"].concat(scribble, snapchat, facebook, youtube, hotjar, google_doubleclick, google_analytics, data, pinterest, optimize),
    frame_ancestors: ["'self'"],
    img_src: ["'self'"].concat(govuk, pinterest, facebook, youtube, twitter, google_supported, google_adservice, google_apis, google_analytics, google_doubleclick, data, lid_pixels, optimize, gtm_server, reddit, %w[cx.atdmt.com linkbam.uk]),
    manifest_src: ["'self'"],
    media_src: ["'self'"].concat(zendesk),
    script_src: ["'self'"].concat(quoted_unsafe_inline, quoted_unsafe_eval, google_analytics, google_supported, google_apis, lid_pixels, govuk, facebook, jquery, pinterest, hotjar, scribble, twitter, snapchat, youtube, zendesk, optimize, reddit),
    style_src: ["'self'"].concat(quoted_unsafe_inline, govuk, google_apis, google_supported, optimize),
    worker_src: ["'self'"].concat(blob),
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[ws: localhost:*]
  end
end
# rubocop:enable Lint/PercentStringArray
