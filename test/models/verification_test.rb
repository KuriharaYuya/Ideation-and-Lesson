require 'test_helper'

class VerificationTest < ActiveSupport::TestCase
  def setup
    @user = User.all[1]
    @micropost = @user.microposts[0]
  end
  test 'should be valid' do
    verification = Verification.new(user_id: @user.id, micropost_id: @micropost.id)
    assert verification.valid?
  end
end
