module Content
  class MailingListComponent < ViewComponent::Base
    attr_reader :title, :intro

    def initialize(title:, intro:)
      super

      @title = title
      @intro = intro
    end

    def privacy_policy
      @privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
    end
  end
end
