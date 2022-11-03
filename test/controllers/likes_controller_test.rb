require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @yuya = users(:yuya)
    @aki = users(:aki)
  end

  test 'guest-user redirect to login_path when like micropost' do
    test_micropost = @aki.microposts[-1]
    # already logged out
    get micropost_path(test_micropost)
    assert_template 'microposts/show'
    get please_login_path
    follow_redirect!
    assert_template 'sessions/new'
  end
end
