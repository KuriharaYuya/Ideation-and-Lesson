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

  test 'should follow and unfollow a user' do
    yuya = users(:yuya)
    naoto = users(:naoto)
    aki = users(:aki)

    assert_not aki.following?(yuya)
    aki.follow(yuya)
    assert aki.following?(yuya)
    aki.unfollow(yuya)
    assert_not aki.following?(yuya)
    assert yuya.followers.include?(naoto)
  end
  test 'email should  be unique ' do
    # create user with existing email
    user = User.new(name: 'Example User', email: User.all[0].email,
                    password: 'foobarbaz', password_confirmation: 'foobarbaz')

    assert_not user.valid?

    # change email to unique
    user[:email] = 'thisis@unique.com'
    assert user.save
    assert user.valid?
  end
end
