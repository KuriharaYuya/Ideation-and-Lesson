require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'user index page should displayed successfully' do
    get users_path
    assert_template 'users/index'
    assert_select 'h1', count: 1
  end
end
