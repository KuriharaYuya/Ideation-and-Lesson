require "test_helper"

class TimelinePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get timeline_pages_home_url
    assert_response :success
  end
end
