module SessionsHelper

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find(Session.find_by(session_token: session[:session_token].session_token).user_id)
  end

  def login!
   if logged_in?
    @sesh_toke = (session_token: session[:session_token].session_token)
   else
    @new_sesh = @user.reset_session_token!
  end

  end

  def login_user!
    create
  end

  def logged_in?
    !!@current_user
  end

  def logout!
    current_user.reset_session_token! if logged_in?
    session[:session_token] = nil
  end

end
