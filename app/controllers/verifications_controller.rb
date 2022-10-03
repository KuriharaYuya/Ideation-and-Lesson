class VerificationsController < ApplicationController
  before_action :user_log_in, only: %w[create destroy index]
  before_action :set_micropost_and_user, only: %w[create destroy index]
  def create
    verification = @micropost.verifications.build(micropost_id: @micropost.id, user_id: @user.id)
    if verification.save! && @micropost.user != current_user
      @micropost.update(verified: true)
      redirect_to micropost_path(@micropost)
    else
      redirect_to login_path
    end
  end

  def destroy
    verification = Verification.find(@micropost.verifications.find_by(user_id: @user.id).id)
    if @user == current_user
      verification.destroy!
      @micropost.update(verified: false)
      redirect_to micropost_path(@micropost)
    else
      redirect_to login_path
    end
  end

  def index
    @micropost = Micropost.find(params[:micropost_id])
    @verifications = @micropost.verifications
  end

  private

  def verifications_params
    params.permit(:micropost_id, :user_id)
  end

  def set_micropost_and_user
    @micropost = Micropost.find(verifications_params[:micropost_id])
    @user = current_user
  end
end
