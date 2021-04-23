class MailingListsController < ApplicationController
  include CircuitBreaker
  layout "registration"

  def new
    @signup = MailingList::Signup.new
  end
end
