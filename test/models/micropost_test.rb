require 'test_helper'
class MicropostTest < ActionDispatch::IntegrationTest
  require 'sessions_helper'
  def setup
    @micropost = microposts(:two)
    @user = users(:yuya)
  end
  test 'should be deleted' do
    assert @micropost.valid?
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash[:notice].present?
    assert_equal '投稿は削除されました', flash[:notice]
  end
end
