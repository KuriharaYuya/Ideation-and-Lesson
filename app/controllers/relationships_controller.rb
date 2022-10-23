class RelationshipsController < ApplicationController
  before_action :user_log_in
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_current_page }
      format.turbo_stream
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      # format.html { redirect_current_page }
      format.turbo_stream
    end
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
