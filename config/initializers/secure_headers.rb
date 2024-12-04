# rubocop:disable Lint/PercentStringArray
SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

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

  facebook    = %w[*.facebook.com *.facebook.net *.connect.facebook.net]
  govuk       = %w[*.gov.uk www.gov.uk]
  jquery      = %w[code.jquery.com]
  pinterest   = %w[*.pinterest.com *.pinterest.co.uk *.pinimg.com]
  snapchat    = %w[*.snapchat.com sc-static.net]
  twitter     = %w[t.co *.twitter.com static.ads-twitter.com analytics.twitter.com]
  youtube     = %w[*.youtube.com *.youtube-nocookie.com i.ytimg.com www.youtube.com www.youtube-nocookie.com]
  sentry      = %w[*.ingest.sentry.io]
  gtm_server  = %w[get-into-teaching-staging-gtm.nw.r.appspot.com analytics.getintoteaching.education.gov.uk]
  reddit      = %w[www.redditstatic.com alb.reddit.com conversions-config.reddit.com]
  clarity     = %w[www.clarity.ms *.clarity.ms *.bing.com]
  vwo         = %w[app.vwo.com *.visualwebsiteoptimizer.com]

  quoted_unsafe_inline = ["'unsafe-inline'"]
  quoted_unsafe_eval   = ["'unsafe-eval'"]
  data                 = ["data:"]
  blob                 = ["blob:"]

  self_base = ["'self'"]

  # We're not sure why yet but the asset host needs to be
  # explicitly whitelisted in the media_src directive or the CSP
  # blocks videos from loading. We don't appear to have this issue
  # with the img_src, oddly.
  assets = []
  assets << ENV["APP_ASSETS_URL"] if ENV["APP_ASSETS_URL"].present?

  config.csp = {
    block_all_mixed_content: true,
    upgrade_insecure_requests: !Rails.env.development?, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w[/csp_reports],

    default_src: %w['none'],
    base_uri: self_base,
    child_src: self_base.concat(youtube, pinterest, snapchat),
    connect_src: self_base.concat(google_apis, pinterest, google_analytics, google_supported, google_doubleclick, facebook, snapchat, sentry, gtm_server, clarity, vwo),
    font_src: self_base.concat(govuk, data, %w[fonts.gstatic.com]),
    form_action: self_base.concat(snapchat, facebook, govuk),
    frame_src: self_base.concat(snapchat, facebook, youtube, google_doubleclick, google_analytics, data, pinterest, clarity, vwo),
    frame_ancestors: self_base,
    img_src: self_base.concat(govuk, pinterest, facebook, youtube, twitter, google_supported, google_adservice, google_apis, google_analytics, google_doubleclick, data, lid_pixels, gtm_server, reddit, clarity, vwo, %w[chart.googleapis.com wingify-assets.s3.amazonaws.com cx.atdmt.com linkbam.uk]),
    manifest_src: self_base,
    media_src: self_base.concat(assets),
    script_src: quoted_unsafe_inline + quoted_unsafe_eval + self_base.concat(google_analytics, google_supported, google_apis, lid_pixels, govuk, facebook, jquery, pinterest, twitter, snapchat, youtube, reddit, clarity, vwo),
    style_src: quoted_unsafe_inline + self_base.concat(govuk, google_apis, google_supported, vwo),
    worker_src: self_base.concat(blob),
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[http://localhost:3035 ws://localhost:3035 wss://localhost:3035]
  end
end

SecureHeaders::Configuration.override(:api) do |config|
  config.csp = { default_src: SecureHeaders::OPT_OUT, script_src: SecureHeaders::OPT_OUT }
  config.hsts = SecureHeaders::OPT_OUT
  config.x_frame_options = SecureHeaders::OPT_OUT
  config.x_content_type_options = SecureHeaders::OPT_OUT
  config.x_xss_protection = SecureHeaders::OPT_OUT
  config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
end

SecureHeaders::Configuration.override(:chat) do |config|
  webchat = %w[*.niceincontact.com ws: wss: ye3ijnvr9l.execute-api.eu-west-2.amazonaws.com/Production/get-access-token tpdfe.satmetrix.com/npxapi/conversation/v1.0/reply tpdfe.satmetrix.com/npxapi/conversation/v1.0/initiate tpdfe.satmetrix.com/npxapi/outcast/v1.0/survey/rules]
  config.csp[:default_src] += webchat
  config.csp[:connect_src] += webchat
  config.csp[:connect_src] << ENV["CHAT_AVAILABILITY_API"]
end

# rubocop:enable Lint/PercentStringArray
