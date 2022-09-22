require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'user index page should displayed successfully' do
    get users_path
    assert_template 'users/index'
  end
end
