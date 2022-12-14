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

    # create user
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    # automatically logged in ?
    assert logged_in?
    follow_redirect!
    assert_template 'users/edit'

    # flash is shown?
    assert_not flash.empty?
    # text of flash is correct ?
    assert flash[:notice] == 'アカウントは正常に作成されました'
    assert flash[:info] == 'あなたのことについて書きましょう'
    assert_select 'div.alert', count: 2

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
    # assert flash.empty?
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

  test 'not unique email is notified by flash' do
    # trying signup with existing email
    post users_path, params: { user: { name: 'Example User',
                                       email: User.all[0].email,
                                       password: 'password',
                                       password_confirmation: 'password' } }
    assert_not flash.empty?
    # flash msg is translated ?
    assert flash[:notice][0].to_s == 'メールアドレスはすでに存在します'
  end

  # =======fix bugs
  # hotfix/#04_remove_dialog_on_home
  test 'should create-success dialog disappeared in home' do
    get root_path
    assert_select 'div.alert', count: 0
  end
  # =======fix bugs end

  test 'should updated, then redirect' do
    bio_text = 'tetetetesy'
    patch user_path(@saved_user), params: { user: { bio: bio_text } }
    assert_equal bio_text, User.find(@saved_user.id).bio

    # redirect successfully?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert flash[:notice] = '変更が完了しました。'
  end
end
