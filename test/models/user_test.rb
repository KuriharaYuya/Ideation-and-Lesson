require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'nikoand01@gmail.com',
                     password: 'foobarbaz', password_confirmation: 'foobarbaz')
  end

  test 'name shoud not empty' do
    @user.name = '    '
    assert_not @user.valid?
  end
  test 'email shoud not empty' do
    @user.email = '    '
    assert_not @user.valid?
  end
  test 'name should not be too long' do
    @user.name = 'a' * 80
    assert_not @user.valid?
    # バリデーションが機能しているかをテストしている
  end
  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
  test 'user should be valid' do
    @user.valid?
  end
end
