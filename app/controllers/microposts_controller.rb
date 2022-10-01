class MicropostsController < ApplicationController
  before_action :user_log_in, only: %w[new create destroy edit update]
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
    @columns = get_all_column_names
  end

  def edit
    @micropost = Micropost.find(params[:id])
    redirect_to_show_unless_wrong_user
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update(micropost_params)
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
    params.require(:micropost).permit(:title, :engagement_status, :post_type)
  end

  def get_all_column_names
    Micropost.column_names
  end

  def redirect_to_show_unless_wrong_user
    redirect_to micropost_path(@micropost) unless @micropost.user == current_user
  end
end
