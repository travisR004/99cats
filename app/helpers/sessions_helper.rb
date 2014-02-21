module SessionsHelper

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find(Session.where(session_token: session[:session_token]).first.user_id)
  end

  def login!
    session[:session_token] = @user.reset_session_token!
  end

  def login_user!
    create
  end

  def logged_in?
    !!current_user
  end

  def logout!
    Session.find_by(session_token: session[:session_token]).destroy!
    session[:session_token] = nil
  end

end
