class MailingListSignupsController < ApplicationController
  class VerifyWithEmptySessionError < StandardError; end

  include CircuitBreaker
  layout "registration"

  SESSION_STORE_KEY = :mailing_list_signup

  def new
    @signup = MailingList::Signup.new
  end

  def create
    @signup = MailingList::Signup.new(new_signup_params)

    if @signup.valid?
      save_signup_to_session

      return redirect_to(edit_mailing_list_signup_path) if @signup.exists_in_crm?

      @signup.add_member_to_mailing_list!
      complete
    else
      render :new
    end
  end

  def edit
    restore_signup_from_session
  rescue VerifyWithEmptySessionError
    redirect_to(new_mailing_list_signup_path)
  end

  def update
    restore_signup_from_session

    @signup.assign_attributes(edit_signup_params)

    if @signup.valid?(:verify)
      save_signup_to_session

      return complete("already_subscribed") if @signup.already_subscribed_to_mailing_list

      @signup.add_member_to_mailing_list!
      complete
    else
      render :edit
    end
  rescue VerifyWithEmptySessionError
    redirect_to(new_mailing_list_signup_path)
  end

private

  def complete(path = "completed")
    session.delete(SESSION_STORE_KEY)
    redirect_to mailing_list_step_path(path)
  end

  def restore_signup_from_session
    signup_data = session[SESSION_STORE_KEY]

    raise VerifyWithEmptySessionError, "tried to confirm identity with blank session" if signup_data.nil?

    @signup = MailingList::Signup.new(**signup_data)
  end

  def save_signup_to_session
    session[SESSION_STORE_KEY] = @signup.export_data
  end

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
    params.require(:mailing_list_signup).permit(:timed_one_time_password)
  end
end
