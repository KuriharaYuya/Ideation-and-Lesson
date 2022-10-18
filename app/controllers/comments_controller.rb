class CommentsController < ApplicationController
  before_action :user_log_in
  # 本人かどうか
  def create
    user = current_user
    micropost = Micropost.find(params[:micropost_id])
    comment = user.comments.build(comment_params)
    redirect_to micropost_path(micropost) if comment.save
    # ダメならエラー文と一緒に返す
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy! if comment.user == current_user
    redirect_to micropost_path(params[:micropost_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :micropost_id)
  end

  # 必要ならuserとmicropostの定義をここで共通関数にして、before_actionしてもいいよ
end
