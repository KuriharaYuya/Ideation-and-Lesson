require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "nikoand01@gmail.com")
  end

  # test "name shoud not empty" do
  #   @user.name = "    "
  #   assert_not @user.valid?
  # end
  # test "email shoud not empty" do
  #   @user.email = "    "
  #   assert_not @user.valid?
  # end
  # test "name should not be too long" do
  #   @user.name = "a" * 60
  #   assert_not @user.valid?
  #   #バリデーションが機能しているかをテストしている
  # end
  # # test "email should have @" do
  # #   @user.email = "nikoand01gmail.com"
  # #   assert_not @user.valid?
  # # end

  test "should be valid" do
    p "#{@user[:name]}だよ"
    p @user
    assert @user.valid?
  end
end
