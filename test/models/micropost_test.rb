require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @micropost = microposts(:two)
    @user = users(:yuya)
  end
  test 'should be valid' do
    assert @micropost.valid?
  end
  test 'title, created_user, engagement_status, post_type should present' do
    @micropost.title = ' '
    assert_not @micropost.valid?
    @micropost.user_id = ' '
    assert_not @micropost.valid?

    @micropost.engagement_status = ' '
    assert_not @micropost.valid?

    @micropost.post_type = ' '
    assert_not @micropost.valid?
  end
end
