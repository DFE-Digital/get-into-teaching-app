class MailingListSignupsController < ApplicationController
  include CircuitBreaker
  layout "registration"

  SESSION_STORE_KEY = :mailing_list_signup

  def new
    @signup = MailingList::Signup.new
  end

  def create
    @signup = MailingList::Signup.new(new_signup_params)

    if @signup.valid?
      if @signup.already_signed_up?
        session[SESSION_STORE_KEY] = @signup.export_data
        return redirect_to(edit_mailing_list_signup_path)
      end

      @signup.add_member_to_mailing_list!
      redirect_to mailing_list_step_path("completed")
    else
      render :new
    end
  end

  def edit
    restore_signup_from_session
  end

  def update
    restore_signup_from_session

    @signup.assign_attributes(edit_signup_params)

    if @signup.valid?(:verify)
      if @signup.already_subscribed_to_mailing_list
        session.delete(SESSION_STORE_KEY)
        return redirect_to mailing_list_step_path("already_subscribed")
      end

      @signup.add_member_to_mailing_list!
      session.delete(SESSION_STORE_KEY)
      redirect_to mailing_list_step_path("completed")
    else
      render :edit
    end
  end

private

  def restore_signup_from_session
    signup_data = session[SESSION_STORE_KEY]

    if signup_data.nil?
      Rails.logger.warn("tried to confirm identity with blank session")
      return redirect_to(new_mailing_list_signup_path)
    end

    @signup = MailingList::Signup.new(**signup_data)
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
