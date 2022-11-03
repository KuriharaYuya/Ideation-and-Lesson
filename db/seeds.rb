# set yuya's 60 microposts

60.times do |n|
  title = "#{n}個目のテスト"
  start_datetime = Time.now
  end_datetime = Time.now
  if Rails.env.development?
    user_id = 4
    lifelog_id = 1
  end
  if Rails.env.test?
    user_id = 913_302_132
    lifelog_id = User.find(user_id).microposts[-1].id
  end
  exec_date = Lifelog.find(lifelog_id).log_date
  posted_at = Time.now - n.minutes
  Micropost.create!(title:, user_id:, start_datetime:, end_datetime:, lifelog_id:, exec_date:, posted?: true,
                    posted_at:, engagement_status: '完了', post_type: 'タイムラプス')
end
