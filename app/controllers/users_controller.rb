class UsersController < ApplicationController
  include UsersHelper
  before_action :user_log_in
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
      redirect_to @user
      # redirect_to user_url(@user.id)
    else
      flash.now[:notice] = @user.errors.full_messages
      # render action: "new"
      render action: 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    reject_other_user_to_access_user_edit_page
  end

  def followers
    @user = User.find_by(id: params[:id])
  end

  def following
    @user = User.find_by(id: params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
