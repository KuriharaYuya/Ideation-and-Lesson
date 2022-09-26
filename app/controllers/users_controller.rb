class UsersController < ApplicationController
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
