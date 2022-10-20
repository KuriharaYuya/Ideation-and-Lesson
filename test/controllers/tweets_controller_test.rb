require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get tweets_edit_url
    assert_response :success
  end

  test "should get new" do
    get tweets_new_url
    assert_response :success
  end
end
