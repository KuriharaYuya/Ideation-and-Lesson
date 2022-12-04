task time_card_test: :environment do
  comments_time_card_to_latest_post
end
def comments_time_card_to_latest_post
  get_lifelog

  time_card = @today_lifelog.time_card

  # 画像のダウンロードと変数への代入
  url = time_card.proof_img.to_s
  puts url
  tgt_file = 'upload.jpg'
  File.open(tgt_file, 'wb') do |file|
    URI.open(url) do |movie|
      file.puts movie.read
    end
  end
  File.delete(tgt_file)

  # create content

  be_on_time = time_card.be_on_time ? '朝の目標達成できました！！' : '朝の目標達成はできませんでした！！'

  recoded_location = "今日は #{time_card.location_today} で プログラミング ！"

  if time_card.gap_min > 0 && time_card.gap_min < 16
    gap_min_on_str = "#{time_card.gap_min}分の遅刻！15分以内なら誤差やろ"
  elsif time_card.gap_min > 15
    gap_min_on_str = "#{time_card.gap_min}分の遅刻！"
  elsif time_card.gap_min < 1
    gap_min_on_str = "#{time_card.gap_min}分早くついたぜ！"
  end
  gap_on_str = "#{time_card.scheduled_time_today.strftime('%R')}到着予定で、#{time_card.arrived_time.strftime('%R')}に到着しました！"

  tomorrow_tgt = "明日は #{time_card.location_tomorrow} で#{time_card.scheduled_time_tomorrow.strftime('%R')}分から勉強するぜ！"

  content = '今日の朝のタイムカード記録！！' + "\n" + recoded_location + "\n" + be_on_time + gap_on_str + "\n" + gap_min_on_str + "\n" + tomorrow_tgt

  puts content
end

def get_lifelog
  user = User.find_by(admin: true)
  @lifelog_id = user.user_setting.post_lifelog_id
  if @lifelog_id.nil?
    puts 'nil'
    @today_date = Date.today.prev_day(user.user_setting.tweet_lifelog_date)
  else
    lifelog = Lifelog.find(@lifelog_id)
    @today_date = lifelog.log_date
    exit if lifelog.tweeted? == true
  end

  @today_lifelog = user.lifelogs.find_by(log_date: @today_date)
end
