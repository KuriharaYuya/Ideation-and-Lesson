class LifelogsController < ApplicationController
  include LifelogsHelper
  before_action :user_log_in, only: %w[create destroy edit update]
  def new
    @lifelog = Lifelog.new
  end

  def create
    @user = current_user
    lifelog = @user.lifelogs.build(lifelog_params)
    redirect_to user_path(@user) if lifelog.save!
  end

  def show
    @lifelog = Lifelog.find(params[:id])
    @user = @lifelog.user
    @microposts = @lifelog.microposts
    @all_column = get_all_column_names(Lifelog)
    return_optional_value_of_lifelog('a')
  end

  def edit
    @lifelog = Lifelog.find(lifelog_params[:id])
    @columns = get_all_column_names(Lifelog)
  end

  def update
    lifelog = Lifelog.find(lifelog_params[:id])
    if lifelog.update(lifelog_params)
      flash[:notice] = '正常に変更されました'
      redirect_to lifelog_path(lifelog)
    else
      flash[:warn] = lifelog.errors.full_messages
      redirect_to edit_lifelog_path(lifelog)
    end
  end

  def destroy
    lifelog = Lifelog.find(lifelog_params[:id])
    redirect_to user_path(lifelog.user) if lifelog.user == current_user && lifelog.destroy!
  end

  private

  def lifelog_params
    params.require(:lifelog).permit(:title, :log_date, :id, :calender, :screen_time, :overview, :assumption_minutes)
  end
end
