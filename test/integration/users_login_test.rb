require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:yuya)
    @user_password = 'password'
  end

  # ログイン

  # 単純にログインできるかどうか？途中の処理は一旦無視する
  test 'should login' do
    log_in_as(@user)
    assert user_logged_in?
  end

  # ログイン状  態を保持するかの選択によって処理が正しく制御されているか？
  ## 保持する
  test 'should remember user' do
    log_in_as(@user, password: @user_password, remember_me: '1')
    @user = User.find(session[:user_id])
    assert_not @user.remember_digest.nil?
  end
  ## 保持しない

  test 'should not remember user' do
    log_in_as(@user, password: @user_password, remember_me: '0')
    @user = User.find(session[:user_id])
    assert @user.remember_digest.nil?
  end

  # 異なるパスワードでログインしようとしたら弾かれるか？

  test 'login with wrong-pass should be prohibited' do
    log_in_as(@user, password: @user_password + 'yeah', remember_me: '0')
    assert_not user_logged_in?
  end

  # ログアウト

  # 単純にログアウトできるか？
  test 'should logout' do
    log_in_as(@user)
    get logout_path
    assert_not user_logged_in?
  end

  # ログアウトするときにremember_digestカラムの値とcookiesを削除できているか？
  test 'remember_digest & cookies should be deleted as logout' do
    log_in_as(@user)
    get logout_path
    assert @user.remember_digest.nil? && !cookies[:remember_token].present?
  end

  # sessionが消えていても(ブラウザを閉じたあとでも)ログインが記憶されているか？
  test 'user should be remembered' do
    log_in_as(@user, remember_me: '1')
    session[:user_id] = nil
    log_in_as(@user, remember_me: '1')
    assert user_logged_in?
    assert_equal(@user, User.find(session[:user_id]))
  end
end
