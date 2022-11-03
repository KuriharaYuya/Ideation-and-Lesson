class UsersController < ApplicationController
  include UsersHelper
  before_action :user_log_in, except: %i[index new create show]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_user_setting
      # login automatically
      session[:user_id] = @user[:id]
      # set flash
      flash[:notice] = 'アカウントは正常に作成されました'
      flash[:info] = 'あなたのことについて書きましょう'
      redirect_to edit_user_path(@user)
    else
      flash.now[:notice] = @user.errors.full_messages
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    reject_other_user_to_access_user_edit_page
  end

  def update
    @user = User.find(params[:id])
    render partial: 'users/updated' if @user.update!(user_params)
  end

  def destroy
    @user = User.find(params[:id])

    if !(@user == current_user)
      redirect_to logout_path
    elsif !password_confirmed?
      flash.now[:notice] = 'パスワードが間違っています'
      redirect_to edit_user_path
    elsif @user.destroy!
      flash[:notice] = 'アカウントは正常に削除されました'
      redirect_to root_path
    end
  end

  def followers
    @user = User.find_by(id: params[:id])
  end

  def following
    @user = User.find_by(id: params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :bio, :profile_img)
  end

  def create_user_setting
    setting = @user.build_user_setting
    setting.save!
  end

  def password_confirmed?
    params.require(:user).permit(:password)
    confirm_password = params[:user][:password].to_s
    @user.authenticate(confirm_password)
  end
end
