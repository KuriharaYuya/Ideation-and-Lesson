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
    if current_page.nil?
      user = User.find_by(id: params(:id))
      redirect_to Something_path
    else
      redirect_to "#{current_page}"
    end
  end
end
