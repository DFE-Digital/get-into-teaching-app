FactoryBot.define do
  factory :mailing_list_privacy_policy, class: "MailingList::Steps::PrivacyPolicy" do
    accept_privacy_policy { "1" }
  end
end
