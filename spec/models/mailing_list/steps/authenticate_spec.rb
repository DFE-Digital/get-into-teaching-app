require "rails_helper"

describe MailingList::Steps::Authenticate do
  include_context "wizard step"

  it { is_expected.to be_kind_of(::Wizard::Steps::Authenticate) }

  it "calls exchange_access_token_for_mailing_list_add_member on valid save" do
    response = GetIntoTeachingApiClient::MailingListAddMember.new
    expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).and_return(response)
    subject.assign_attributes(attributes_for(:authenticate))
    subject.save
  end
end
