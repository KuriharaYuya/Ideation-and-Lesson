class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    p params
    @user = User.find(params[:id])
  end

  def create
    # p params[:user]
    @user = User.new(user_params)
    if @user.save
      p "/users/#{params[:id]}"
      redirect_to @user
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
