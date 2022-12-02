require 'test_helper'

class TimeCardsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @saved_user = users(:yuya)
    # login
    post login_url, params: { session: { email: @saved_user.email, password: 'password' } }

    @i = 0
    lifelogs.each do |lifelog|
      lifelog.update!(user_id: users(:yuya).id)
      lifelog.update!(log_date: Date.today.prev_day(@i))
      @i += 1
    end
    @lifelogs = lifelogs
  end

  test 'time_card_created' do
    # lifelog creatad?
    get new_micropost_url
    created_lifelog = Lifelog.all.last
    assert_equal created_lifelog.log_date, Date.today
    assert_not created_lifelog.time_card.nil?
    assert_not created_lifelog.time_card.lifelog_id.nil?
    # lifelog created by micropost#new
    Lifelog.all.last.update(log_date: Date.yesterday)
    get new_micropost_url
    yesterday_lifelog = Lifelog.all[-1].time_card.set_yesterday_lifelog
    yesterday_lifelog.build_time_card
    yesterday_lifelog.time_card.update(scheduled_time_tomorrow: Time.now - (60 * 10))
    yesterday_lifelog.time_card.save
    #  lifelog prev imported test
    today_lifelog = Lifelog.find_by(log_date: Date.today)
    today_lifelog.time_card.update(scheduled_time_today: yesterday_lifelog.time_card.scheduled_time_tomorrow)
    assert_equal today_lifelog.time_card.scheduled_time_today, yesterday_lifelog.time_card.scheduled_time_tomorrow

    # yesterday_lifelog does not exist,
    # yesterday_lifelog.update(log_date: Date.today.prev_day(100))
    p TimeCard.all.length
    yesterday_lifelog.destroy
    today_lifelog.update(log_date: today_lifelog.log_date.prev_day(10))
    assert_equal Lifelog.all.where(log_date: Date.today), []

    get new_micropost_url
    assert_equal Lifelog.all.where(log_date: Date.today).length, 1
    created_lifelog = Lifelog.all.last
    p created_lifelog.log_date
    p TimeCard.all[0].lifelog.log_date
    p TimeCard.all.length
    assert_equal created_lifelog.log_date, Date.today
    assert_not created_lifelog.time_card.nil?
    assert_not created_lifelog.time_card.lifelog_id.nil?

    # assert_not today_lifelog.time_card.nil?
  end
end
