class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_current_page
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    redirect_current_page
  end

  private

  def redirect_current_page
    current_page = params[:current_page]
    if current_page == "#{users_path}/#{@user.id}"
      redirect_to @user
    else
      redirect_to users_path
    end
  end
end
