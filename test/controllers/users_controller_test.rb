require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  require 'sessions_helper'
  def setup
    @saved_user = users(:yuya)
    # login
    post login_url, params: { session: { email: @saved_user.email, password: 'password' } }
  end
  test 'debug' do
  end
  test 'should created' do
    # logout
    get logout_url

    # delete user
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    # automatically logged in ?
    assert logged_in?
    follow_redirect!

    assert_template 'users/show'
  end

  test 'should deleted' do
    # login
    post login_url, params: { session: { email: @saved_user.email, password: 'password' } }

    assert_difference 'User.count', -1 do
      delete user_path(@saved_user), params: { user: { password: 'password' } }
    end
    # follow_redirect!
    # assert_template
  end
end
