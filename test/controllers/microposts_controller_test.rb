require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.find(users(:yuya).id)
    @microposts = @user.microposts
    @micropost = Micropost.find(microposts(:one).id)
  end

  test 'micropost create ' do
    assert_difference 'Micropost.count', +1 do
      post microposts_path(@micropost)
    end
  end

  # test 'micropost delete' do
  #   # create micropost for test
  #   @micropost.save

  #   assert_difference 'Micropost.count', -1 do
  #     @user.destroy
  #     assert_difference ".count", 1 do
        
  #     end
  #   end
  # end

  # test "micropost update" do
  #   title = @micropost.title

  # end
end
