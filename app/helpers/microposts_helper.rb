module MicropostsHelper
  def can_post?
    true if @micropost.engagement_status == '完了' && !posted?
  end

  def posted?
    @micropost.posted? == true
  end

  def prompt_post
    flash[:notice] = '投稿する準備が完了しています' if can_post?
    flash[:notice] = '既に投稿された投稿を書き換えました' if posted?
  end
end
