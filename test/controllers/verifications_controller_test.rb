require 'test_helper'

class VerificationsControllerTest < ActionDispatch::IntegrationTest
  test 'should  create successfully' do
    get verifications_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get verifications_destroy_url
    assert_response :success
  end
end
