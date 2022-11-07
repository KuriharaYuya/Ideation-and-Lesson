require 'User'
class LikesController < ApplicationController
  include ApplicationHelper
  before_action :user_log_in, only: %w[create destroy]
  def index
    params[:micropost_id] = nil if params[:micropost_id] && params[:comment_id]
    @post = Micropost.find(params[:micropost_id]) if params[:comment_id].nil?
    @post = Comment.find(params[:comment_id]) if params[:micropost_id].nil?
    @likes = @post.likes
  end

  def create
    @post = Micropost.find(params[:like][:micropost_id]) if params[:like][:comment_id].nil?
    if @post.nil? && !(params[:like][:micropost_id].nil? && params[:like][:comment_id].nil?)
      @post = Comment.find(params[:like][:comment_id])
      params[:micropost_id] = nil
    end

    like = @post.likes.build(like_params)
    like[:micropost_id] = nil if @post.instance_of?(Comment)
    like.save!
    @post.create_notification_like_for_micropost(current_user)
    redirect_to micropost_path(params[:like][:micropost_id])
  end

  def destroy
    like = Like.find(params[:like][:like_id])
    like.destroy! if like.user == current_user
    redirect_to micropost_path(params[:like][:micropost_id])
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :micropost_id, :comment_id)
  end

  def liked?
    @post = Micropost.find(params[:micropost_id])
    @post ||= Comment.find(params[:comment_id])
    @post.likes.find_by(user_id: current_user.id)
  end
end
