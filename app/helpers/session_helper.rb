module SessionHelper
  def event_session
    session[:events] ||= {}
    session[:events][params[:event_id]] ||= {}
  end

  def mailing_list_session
    session[:mailinglist] ||= {}
  end

  def callbacks_session
    session[:callbacks] ||= {}
  end
end
