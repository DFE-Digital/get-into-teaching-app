class Home::MailingListComponent < ViewComponent::Base
  def privacy_policy
    @privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
  end
end
