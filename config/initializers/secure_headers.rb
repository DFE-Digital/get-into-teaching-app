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
    https://googleads.g.doubleclick.net
    https://ssl.google-analytics.com
    https://tagmanager.google.com
  ]

  # curl https://www.google.com/supported_domains > config/csp/google_supported_domains.csv
  google_supported = File.readlines(Rails.root.join("config", "csp", "google_supported_domains.csv"), chomp: true)

  google_adservice = %w[adservice.google.com adservice.google.co.uk]
  google_doubleclick = %w[*.doubleclick.net *.googleads.g.doubleclick.net stats.g.doubleclick.net]
  google_apis = %w[*.googleapis.com https://fonts.googleapis.com]

  facebook = %w[*.facebook.com]
  govuk = %w[*.gov.uk www.gov.uk]
  hotjar = %w[*.hotjar.com vc.hotjar.io wss://*.hotjar.com]
  jquery = %w[code.jquery.com]
  linkbam = %w[linkbam.uk]
  pinterest = %w[*.pinterest.com ct.pinterest.com]
  scribble = %w[embed.scribblelive.com]
  snapchat = %w[*.snapchat.com sc-static.net]
  twitter = %w[*.twitter.com static.ads-twitter.com analytics.twitter.com]
  vwo = %w[*.visualwebsiteoptimizer.com, dev.visualwebsiteoptimizer.com]
  youtube = %w[*.youtube.com *.youtube-nocookie.com i.ytimg.com www.youtube.com www.youtube-nocookie.com]

  quoted_none          = ["'none'"]
  quoted_unsafe_inline = ["'unsafe-inline'"]
  quoted_unsafe_eval   = ["'unsafe-eval'"]
  quoted_self          = ["'self'"]
  data                 = ["data:"]
  blob                 = ["blob:"]

  config.csp = {
    block_all_mixed_content: true,
    upgrade_insecure_requests: !Rails.env.development?, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w[/csp_reports],

    #   default_src: %w['none'],
    default_src: quoted_none,

    #   base_uri: %w['self'],
    base_uri: quoted_self,

    # child_src: %w['self' *.youtube.com ct.pinterest.com *.snapchat.com *.hotjar.com],
    child_src: quoted_self.concat(youtube, pinterest, snapchat, hotjar),

    # connect_src: %w['self' ct.pinterest.com *.hotjar.com vc.hotjar.io wss://*.hotjar.com *.facebook.com *.visualwebsiteoptimizer.com stats.g.doubleclick.net] + google_domains + tta_service_hosts,
    connect_src: quoted_self.concat(pinterest, hotjar, google_analytics, google_supported, google_doubleclick, vwo, facebook, tta_service_hosts),

    # font_src: %w['self' *.gov.uk fonts.gstatic.com data:],
    font_src: quoted_self.concat(govuk, data, %w[fonts.gstatic.com]),

    # form_action: %w['self' *.snapchat.com *.facebook.com www.gov.uk dev.visualwebsiteoptimizer.com],
    form_action: quoted_self.concat(snapchat, facebook, vwo, govuk),

    # frame_src: %w['self' embed.scribblelive.com *.snapchat.com *.facebook.com www.youtube.com www.youtube-nocookie.com *.hotjar.com *.doubleclick.net dev.visualwebsiteoptimizer.com *.googlesyndication.com https://bid.g.doubleclick.net],
    frame_src: quoted_self.concat(scribble, snapchat, facebook, youtube, hotjar, google_doubleclick, vwo, google_analytics),


    # frame_ancestors: %w['self'],
    frame_ancestors: quoted_self,

    # img_src: %w['self' linkbam.uk *.gov.uk data: *.googleapis.com *.pinterest.com t.co *.facebook.com cx.atdmt.com *.visualwebsiteoptimizer.com *.doubleclick.net i.ytimg.com adservice.google.com adservice.google.co.uk https://pixelg.adswizz.com] + google_domains + lid_pixels,
    img_src: quoted_self.concat(linkbam, govuk, pinterest, facebook, vwo, youtube, google_adservice, google_apis, data),

    # manifest_src: %w['self'],
    manifest_src: quoted_self,

    # media_src: %w['self'],
    media_src: quoted_self,

    # script_src: %w['self' 'unsafe-inline' 'unsafe-eval' embed.scribblelive.com *.googleapis.com *.gov.uk code.jquery.com *.facebook.net *.hotjar.com *.pinimg.com sc-static.net static.ads-twitter.com analytics.twitter.com
    #                *.youtube.com *.visualwebsiteoptimizer.com https://www.googletagmanager.com/gtm.js] + google_domains + lid_pixels,
    script_src: quoted_self.concat(quoted_unsafe_inline, quoted_unsafe_eval, google_analytics, google_supported, google_apis, lid_pixels, govuk, facebook, hotjar, scribble, twitter, snapchat, vwo),

    #   style_src: %w['self' 'unsafe-inline' *.gov.uk *.googleapis.com] + google_domains,
    style_src: quoted_self.concat(quoted_unsafe_inline, govuk, blob, google_apis),

    #   worker_src: %w['self' *.visualwebsiteoptimizer.com blob:],
    worker_src: quoted_self.concat(vwo, blob),
  }

  if Rails.env.development?
    # Webpack-dev-server
    config.csp[:connect_src] += %w[ws: localhost:*]
  end
end
# rubocop:enable Lint/PercentStringArray
