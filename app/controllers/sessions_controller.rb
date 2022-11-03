class SessionsController < ApplicationController
  def new; end

  def create
    # sessionを取得しuser変数にて定義
    user = User.find_by(email: params[:session][:email].downcase)
    @user = user
    if user && user.authenticate(params[:session][:password])
      reset_session
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in(user)
      redirect_to @user
    else
      flash.now[:notice] = 'ログイン情報が間違っているか、登録されていないアカウントです'
      render :new
    end
  end

  def please_login
    flash[:notice] = 'ログインしてください'
    redirect_to login_path
  end

  def destroy
    forget(current_user)
    log_out
    @current_user = nil
    redirect_to root_path
  end
end
