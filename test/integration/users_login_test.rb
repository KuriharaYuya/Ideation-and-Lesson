require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:yuya)
    @user_params = { session: { email: 'nikoand01@gmail.com', password: 'password' } }
  end
  test 'login with valid user info' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: @user_params
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'h1', text: "Here is#{@user[:name]}'s page"
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
    assert_select 'a[href=?]', logout_path
  end
  test 'logout' do
    get login_path
    post login_path, params: @user_params
    get logout_path
    follow_redirect!
    assert_template root_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', logout_path, count: 0
  end
end
