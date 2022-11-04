require 'test_helper'

class TimelinePagesControllerTest < ActionDispatch::IntegrationTest
  test 'showing h5 as reached micropost limits' do
    number_of_get_posts = 1000
    get root_path, params: { post_length: number_of_get_posts }
    assert_select 'h5.no_more_posts_msg', count: 1
  end
end
