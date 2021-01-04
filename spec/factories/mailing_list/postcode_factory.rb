FactoryBot.define do
  factory :mailing_list_postcode, class: "MailingList::Steps::Postcode" do
    address_postcode { "TE571NG" }
  end
end
