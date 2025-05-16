class Home::MailingListComponent < ViewComponent::Base
  def privacy_policy
    @privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
    # @privacy_policy ||= Struct.new(:id).new(id: 1) # FIXME! # GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
  end
end
