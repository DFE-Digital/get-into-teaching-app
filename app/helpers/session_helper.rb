module SessionHelper
  def event_session
    session[:events] ||= {}
    session[:events][params[:event_id]] ||= {}
  end
end
