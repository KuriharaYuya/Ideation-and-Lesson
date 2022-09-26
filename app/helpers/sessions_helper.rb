module SessionsHelper
  def log_in(user)
    session[:user_id] = user[:id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    reset_session
    @current_user = nil
  end

  def user_log_in
    flash.now[:notice] = 'ログインもしくはサインアップをしてください'
    render 'sessions/new' unless logged_in?
  end

  def store_location
    session[:return_to] = request.url
  end
end
