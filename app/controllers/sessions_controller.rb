class SessionsController < ApplicationController
  def new
    flash = ""
  end

  def create
    #sessionを取得しuser変数にて定義
    user = User.find_by(email: params[:session][:email].downcase)
    @user = user
    #処理
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in(user)
      redirect_to @user
    else
      flash.now[:notice] = "ログイン情報が間違っているか、登録されていないアカウントです"
      render :new
    end
  end
  def destroy
    log_out
    redirect_to root_path
  end
end