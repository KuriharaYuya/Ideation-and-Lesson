require 'test_helper'

class LifelogAutoAssignmentTest < ActionDispatch::IntegrationTest
  def setup
    # he hasn't any lifelog
    @user = users(:naoto)
    # # login
    log_in_as(@user)
  end
  test 'user really have not any lifelog?' do
    assert_equal @user.microposts.length, 0
  end

  test 'lifelog automatically created with micropost#new' do
    # create micropost, then binded lifelog would be created
    assert_difference 'Lifelog.count', 1 do
      get new_micropost_path
    end
    assert_template 'microposts/new'

    created_lifelog = Lifelog.all.last
    assert_equal Date.today, created_lifelog.log_date
  end
end
