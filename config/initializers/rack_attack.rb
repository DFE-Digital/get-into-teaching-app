module Rack
  class Attack
    FAIL2BAN_LIST = %w[
      /etc/passwd
      wp-admin
      wp-login
      wp-includes
      .php
    ].freeze

    FAIL2BAN_REGEX = Regexp.union(FAIL2BAN_LIST).freeze

    # Throttle /csp_reports requests by IP (5rpm)
    throttle("csp_reports req/ip", limit: 5, period: 1.minute) do |req|
      req.ip if req.path == "/csp_reports"
    end

    unless ENV["SKIP_REQ_LIMITS"].to_s.in? %w[true yes 1]
      # Throttle requests that issue a verification code by IP (5rpm)
      throttle("issue_verification_code req/ip", limit: 5, period: 1.minute) do |req|
        issue_verification_code_paths = [
          %r{mailinglist/signup/name},
          %r{events/.*/apply/personal_details},
        ]

        path_issues_verification_code = issue_verification_code_paths.any? do |pattern|
          pattern.match(req.path)
        end

        req.ip if (req.patch? || req.put?) && path_issues_verification_code
      end

      # Throttle requests that resend a verification code by IP (5rpm)
      throttle("resend_verification_code req/ip", limit: 5, period: 1.minute) do |req|
        path_resends_verification_code = %r{/*./resend_verification}.match?(req.path)

        req.ip if req.get? && path_resends_verification_code
      end

      # Throttle mailing list sign ups by IP (5rpm)
      throttle("mailing_list_sign_up req/ip", limit: 5, period: 1.minute) do |req|
        req.ip if (req.patch? || req.put?) && req.path == "/mailinglist/signup/privacy_policy"
      end

      # Throttle event sign ups by IP (5rpm)
      throttle("event_sign_up req/ip", limit: 5, period: 1.minute) do |req|
        event_sign_up_paths = [
          %r{events/.*/apply/personalised_updates},
          %r{events/.*/apply/further_details},
        ]

        path_performs_event_sign_up = event_sign_up_paths.any? do |pattern|
          pattern.match(req.path)
        end

        req.ip if (req.patch? || req.put?) && path_performs_event_sign_up
      end

      # Throttle event upsert by IP (5rpm)
      throttle("event upsert", limit: 5, period: 1.minute) do |req|
        event_upsert_paths = [
          %r{/internal/events},
          %r{/internal/approve},
        ]

        req.ip if event_upsert_paths.any? { |path| req.path.match(path) } && (req.post? || req.put?)
      end
    end

    if ENV["FAIL2BAN"].to_s.match? %r{\A\d+\z}
      FAIL2BAN_TIME = ENV["FAIL2BAN"].to_s.to_i.minutes.freeze

      blocklist("block hostile bots") do |req|
        Fail2Ban.filter("hostile-bots-#{req.ip}", maxretry: 0, findtime: 1.second, bantime: FAIL2BAN_TIME) do
          (
            FAIL2BAN_REGEX.match?(CGI.unescape(req.query_string)) ||
              FAIL2BAN_REGEX.match?(req.path)
          ).tap do |should_ban|
            if should_ban
              obscured_ip = req.ip.to_s.gsub(%r{\.\d+\.(\d+)\.}, ".***.***.")

              Rails.logger.info(
                <<~BAN_MESSAGE,
                  Banning IP: #{obscured_ip} for #{FAIL2BAN_TIME.to_i / 60} minutes
                  accessing #{req.path} with '#{req.query_string}'
                BAN_MESSAGE
              )
            end
          end
        end
      end
    end
  end

  Rack::Attack.throttled_response = lambda do |env|
    accept_html = env["HTTP_ACCEPT"].include?("text/html")
    return [429, {}, ["Rate limit exceeded"]] unless accept_html

    html = ApplicationController.render(
      template: "errors/too_many_requests",
    )

    [429, { "Content-Type" => "text/html" }, [html]]
  end
end
