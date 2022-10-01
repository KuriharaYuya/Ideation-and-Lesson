require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:yuya)
    @current_user = @user
    @microposts = @user.microposts
    @micropost = @microposts[0]
    @micropost[:user_id] = @user.id
    # createとdestroyだけログイン処理を走らせよう->test_helperに書こうかな
  end

  test 'comments created successfully' do
    assert_difference 'Comment.count', +1 do
      post micropost_comments_path(@micropost),
           params: { comment: { content: comments(:one).content, micropost_id: comments(:one).micropost_id } }
    end
  end

  test 'comments destroyed successfully' do
    assert_difference 'Comment.count', -1 do
    end
  end
end
