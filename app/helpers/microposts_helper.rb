module MicropostsHelper
  def can_post?
    true if @micropost.engagement_status == '完了' && !posted?
  end

  def posted?
    @micropost.posted? == true
  end

  def prompt_post
    can_post?
    flash[:notice] = '投稿する準備が完了しています'
  end
end
