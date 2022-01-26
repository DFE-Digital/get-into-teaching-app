class Registration::MailingListSignupConfirmationComponent < ViewComponent::Base
  attr_reader :mailing_list_session

  def initialize(mailing_list_session)
    super

    @first_name = mailing_list_session["first_name"]
  end

  def heading_text
    if @first_name.present?
      %(#{@first_name}, you're signed up)
    else
      %(You've signed up)
    end
  end
end
