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

    # flash is shown?
    assert_not flash.empty?
    # text of flash is correct ?
    assert flash[:notice] == 'アカウントは正常に作成されました'

    # flash msg have disappear after moved page ?
    get root_path
    assert flash.empty?
  end

  test 'signup with invalid data' do
    post users_path, params: { user: { name: '',
                                       email: 'user@example.com',
                                       password: 'password',
                                       password_confirmation: 'password' } }
    #  flash is shown?
    assert_not flash.empty?
    # flash have been translated?
    assert flash[:notice][0] == '名前が空になっています。入力してください。'

    # flash msg have disappear after moved page ?
    get root_path
    assert flash.empty?
  end

  test 'should deleted' do
    # login
    post login_url, params: { session: { email: @saved_user.email, password: 'password' } }

    # delete
    assert_difference 'User.count', -1 do
      delete user_path(@saved_user), params: { user: { password: 'password' } }
    end
    follow_redirect!
    assert_template

    # flash is shown?
    assert_not flash.empty?

    # text of flash is correct?
    assert flash[:notice] == 'アカウントは正常に削除されました'

    # flash msg have disappear after moved page ?
    get login_path
    assert flash.empty?
  end

  test 'trying delete user with invalid password' do
    # login
    post login_url, params: { session: { email: @saved_user.email, password: 'password' } }

    #  delete with invalid pass
    delete user_path(@saved_user), params: { user: { password: 'KawaiiTwice!!' } }

    # flash is shown ?
    assert_not flash.empty?
    # text of flash is correct ?
    assert flash[:notice] == 'パスワードが間違っています'

    # flash msg have disappear after moved page ?
    get root_path
    assert flash.empty?
  end
end
