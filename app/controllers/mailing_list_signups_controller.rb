class MailingListSignupsController < ApplicationController
  include CircuitBreaker
  layout "registration"

  def new
    @signup = MailingList::Signup.new
  end

  def create
    @signup = MailingList::Signup.new(new_signup_params)

    if @signup.valid?
      # check if they've already signed up
      #
      # if yes, save their data to the session and redirect to #update (/personalised-updates/verify)
      #
      # if no, submit their data to the API
    else
      render :new
    end
  end

  def edit
    # they've already signed up to the mailing list, so here we'd ask them for a
    # code to check they own the email address/account
  end

  def update
    @signup = MailingList::Signup.new_from_session

    # send their data along with the verification code to the API? Probably
  end

private

  def new_signup_params
    params
      .require(:mailing_list_signup)
      .permit(
        :preferred_teaching_subject_id,
        :consideration_journey_stage_id,
        :accept_privacy_policy,
        :accepted_policy_id,
        :address_postcode,
        :first_name,
        :last_name,
        :email,
        :channel_id,
        :degree_status_id,
      )
  end

  def edit_signup_params
    params.require(:mailing_list_signup).permit(:verification_code)
  end
end
