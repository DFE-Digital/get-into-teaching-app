module Footer
  class CookieAcceptanceComponent < ViewComponent::Base
    def render?
      return true if request.user_agent.blank?

      # we're being penalised by Silktide's accessibility checker because
      # our cookie banner is blocking the screen. Silktide's user agents
      # all have the suffix Silktide, so for them simply don't show the
      # cookie acceptance popup.
      #
      # https://support.silktide.com/guides/ip-address-user-agent-silktide-use/

      !request.user_agent.end_with?("Silktide")
    end
  end
end
