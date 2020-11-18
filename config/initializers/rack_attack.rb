module Rack
  class Attack
    # Throttle /csp_reports requests by IP (5rpm)
    throttle("csp_reports req/ip", limit: 5, period: 1.minute) do |req|
      req.ip if req.path == "/csp_reports"
    end

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
  end

  Rack::Attack.throttled_response = lambda do |env|
    accept_html = env["HTTP_ACCEPT"].include?("text/html")
    return [429, {}, "Rate limit exceeded"] unless accept_html

    html = ApplicationController.render(
      template: "errors/too_many_requests",
    )

    [429, { "Content-Type" => "text/html" }, [html]]
  end
end
