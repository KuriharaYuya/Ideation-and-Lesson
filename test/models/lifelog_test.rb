require 'test_helper'
require 'active_support/time'
include LifelogsHelper

class LifelogTest < ActiveSupport::TestCase
  def setup
    @lifelog = lifelogs(:one)
    @lifelog.update!(user_id: users(:yuya).id)
    set_current_datetime_to_logdate
    @user = users(:yuya)
  end
  # test 'should uniqueness validation work' do
  #   log = Lifelog.new(title: 'MyString', user_id: users(:naoto).id)
  #   begin
  #     log.save!
  #   rescue StandardError => e
  #     assert e.message == 'Validation failed: Log date has already been taken'
  #   end
  # end

  # test 'start_datetime and end_datetime should be set by log_date' do
  #   start_datetime = nil
  #   end_datetime = nil
  #   set_lifelog_duration_time('calc')
  #   assert @lifelog[:start_datetime] == @lifelog[:log_date] + set_lifelog_duration_time('start')
  #   assert @lifelog[:end_datetime] == @lifelog[:start_datetime] + set_lifelog_duration_time('duration')
  # end

  test 'datetime_duration should not overlap with that of other lifelog ' do
    # @lifelog = Lifelog.new(title: 'string', user_id: users(:yuya).id)
    # @lifelog[:log_date] = @lifelog[:log_date].tomorrow
    # set_lifelog_duration_time('calc')
    # @lifelog.save!
    # assert_not is_duration_overlap?
  end

  test 'micropost should be bound proper lifelog' do
    @micropost = @user.microposts[0]
    current_datetime = Date.today
    @micropost.update(exec_date: current_datetime)
    assign_lifelog_to_micropost if @micropost.lifelog.nil?
    assert @micropost.lifelog.present?
    # assert @micropost.end_datetime.before? @micropost.lifelog.end_datetime
  end
end
