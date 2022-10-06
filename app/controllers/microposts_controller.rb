class MicropostsController < ApplicationController
  include ApplicationHelper
  def new
    @micropost = Micropost.new
  end

  def create
    user = current_user
    micropost = user.microposts.build(micropost_params)
    micropost.save
    redirect_to micropost_path(micropost.id)
  end

  def show
    @micropost = Micropost.find(params[:id])
    @user = @micropost.user
    @comment = @user.comments.new
    @columns = get_all_column_names(Micropost)
    @like = @micropost.likes.find_by(user_id: current_user.id) || Like.new
  end

  def edit
    @micropost = Micropost.find(params[:id])
    redirect_to_show_unless_wrong_user
  end

  def update
    @micropost = Micropost.find(micropost_params[:id])
    if @micropost.update(micropost_params)
      update_calculated_minutes
      @micropost.update(verified: false) if micropost_params[:post_type] != 'タイムラプス'
      redirect_to micropost_path(@micropost)
    else
      render :edit
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    user = @micropost.user
    @micropost.destroy!
    redirect_to user_path(user)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:title, :engagement_status, :post_type, :start_datetime, :end_datetime,
                                      :assumption_minutes, :id)
  end

  def redirect_to_show_unless_wrong_user
    redirect_to micropost_path(@micropost) unless @micropost.user == current_user
  end

  def update_calculated_minutes
    if @micropost[:engagement_status] == '予定'
      type = 'assumption'
    elsif @micropost[:engagement_status] == '完了' || @micropost[:engagement_status] == '未完了'
      type = 'consuming'
    end
    result = ((@micropost.end_datetime - @micropost.start_datetime) / 60.0)
    if @micropost.user == current_user
      if type == 'consuming'
        @micropost.update!(consuming_minutes: result)
      elsif type == 'assumption'
        @micropost.update!(assumption_minutes: result) if overwritten? && (@micropost[:engagement_status] == '予定')
      end
    end
  end

  def overwritten?
    !params[:overwritten_option].nil?
  end
end
