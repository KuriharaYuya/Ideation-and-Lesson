desc 'twitter movie test'
task twitter_mov_test: :environment do
  # ここから処理を書いていく
  require 'twitter'
  # require 'json'
  set_lifelogs
  mov_upload
  comments_daily_overview_to_latest_post
  time_card_upload
end
def mov_upload
  @twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
  url = @timelapse_url
  p url
  tgt_file = 'upload.mov'
  File.open(tgt_file, 'wb') do |file|
    URI.open(url) do |movie|
      file.puts movie.read
    end
  end
  mov = File.new(open(tgt_file))
  init_request = Twitter::REST::Request.new(@twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                                            { command: 'INIT', total_bytes: mov.size, media_type: 'video/mov', media_category: 'tweet_video' }).perform
  p 'init is completed'
  @i = 1
  until mov.eof?
    base64_chunk = Base64.encode64(mov.read(5_000_000))
    base64_chunk.delete("\n")
    seg ||= -1
    p @i
    @i += 1
    Twitter::REST::Request.new(@twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                               { command: 'APPEND', media_id: init_request[:media_id], media_data: base64_chunk, segment_index: seg += 1, key: :media }).perform
  end
  p 'append is completed'
  mov.close
  Twitter::REST::Request.new(@twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                             { command: 'FINALIZE', media_id: init_request[:media_id] }).perform
  p 'F is completed'
  @f = 1
  restore
  begin
    puts @tweet_content
    p @tweet_content.length
    @twitter_client.update(
      @tweet_content, media_ids: init_request[:media_id]
    )
  rescue Twitter::Error::BadRequest
    sleep 10
    @f += 1
    p 'mooo'
    retry
  rescue Twitter::Error::Forbidden
    @wrong_times ||= 1
    @wrong_times += 1
    p 'saaaa'
    restore
    retry
  end
  File.delete(tgt_file)
end

def restore
  @tweet_micropost_logs = []
  @micropost_consuming_sum = []
  # 配列にして、要素ごとに説明を入れる
  @i = 1
  @today_microposts = @today_lifelog.microposts.order(start_datetime: :asc)
  @timelapse_timetable_numb = @today_microposts[0]
  @today_microposts.each do |micropost|
    next unless micropost.engagement_status == '完了'

    p micropost.title
    @micropost_consuming_sum.push(micropost.consuming_minutes)
    str = "#{@i}限目: #{micropost.title} #{to_HH_MM(micropost.consuming_minutes)}\n"
    @tweet_micropost_logs.push(str)
    @timelapse_timetable_numb = @i if @timelapse_timetable_numb == micropost
    @i += 1
  end
  @micropost_consuming_sum = @micropost_consuming_sum.sum
  if @today_lifelog.assumption_minutes.present?
    @assumption_gap = (@micropost_consuming_sum - @today_lifelog.assumption_minutes)
  end

  @tweet_microposts = []
  if @wrong_times.nil?
    @tweet_micropost_logs.each do |log|
      @tweet_microposts.push(log)
    end
  elsif @wrong_times.present?
    @tweet_microposts = []
    @upto = @tweet_micropost_logs.size - 1
    @f = 1
    @tweet_micropost_logs.each do |log|
      break if @upto == @f

      @f += 1
      @tweet_microposts.push(log)
    end

    summed_microposts_numb = @today_microposts.size - @tweet_microposts.size
    summed_microposts = @today_microposts.reverse[0..(summed_microposts_numb - 1)]

    @summed_microposts_consuming_minutes = 1
    summed_microposts.each do |micropost|
      @summed_microposts_consuming_minutes += micropost.consuming_minutes
    end
    @summed_microposts_consuming_minutes -= 1
    @summed_microposts_consuming_minutes = to_HH_MM(@summed_microposts_consuming_minutes)
    # そもそものマイクロポストから取得して、配列番号を返す、そんでhhmmで計算して@sumで取得して終わり
    @sum_message = "その他#{summed_microposts.size}件の合計が#{@summed_microposts_consuming_minutes}"
  end
  @tweet_microposts = if @sum_message.present?
                        @tweet_microposts.join + "\n" + @sum_message
                      else
                        @tweet_microposts.join
                      end

  # からのjoinで改行させて結合
  tweet_header = '💻Hello world💻'
  tweet_title = "#{@today_lifelog.log_date}の記録🥺\n"
  tweet_asp_gap = if @assumption_gap.nil?
                    ''
                  else
                    " 予定より#{@assumption_gap}分! "
                  end
  tweet_lifelog_sum = "合計で#{to_HH_MM(@micropost_consuming_sum)}#{tweet_asp_gap}明日も頑張ります！"
  tweet_hashtag = '#駆け出しエンジニアと繋がりたい'
  @tweet_content = tweet_header + "\n" + tweet_title + "\n" + @tweet_microposts + tweet_lifelog_sum + "\n" + tweet_hashtag + "\n" + "↓は#{@timelapse_timetable_numb}限目の様子です!"
end

def set_lifelogs
  user = User.find_by(admin: true)
  @lifelog_id = user.user_setting.post_lifelog_id
  puts user.name
  puts @lifelog_id
  if @lifelog_id.nil?
    puts 'nil'
    @today_date = Date.today.prev_day(user.user_setting.tweet_lifelog_date)
  else
    lifelog = Lifelog.find(@lifelog_id)
    @today_date = lifelog.log_date
    exit if lifelog.tweeted? == true
  end
  puts @today_date
  @today_lifelog = user.lifelogs.find_by(log_date: @today_date)
  puts @today_lifelog
  @today_microposts = @today_lifelog.microposts.order(consuming_minutes: :desc)
  @longest_timelapse_micropost = nil
  consuming_order = @today_microposts.order(consuming_minutes: :desc)
  consuming_order.each do |tgt|
    unless tgt.engagement_status == '完了' && tgt.post_type == 'タイムラプス' && tgt.consuming_minutes.present? && tgt.video.present?
      next
    end

    @longest_timelapse_micropost = tgt
    break
  end
  @timelapse_url = @longest_timelapse_micropost.video.url
end

def to_HH_MM(minutes)
  hour = minutes / 60
  min = minutes - hour * 60
  "#{hour}時間#{min}分"
end

def comments_daily_overview_to_latest_post
  p 'now in process of commenting'
  my_twitter_user_id = '3223240382'.to_i
  @twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
  @tweets = @twitter_client.user_timeline(user_id: my_twitter_user_id, count: 1, exclude_replies: false, include_rts: false,
                                          contributor_details: false, result_type: 'recent', locale: 'ja', tweet_mode: 'extended')

  # calenderとscreen_timeのurlを取得してhashに格納
  @comments_content = @today_lifelog.overview.to_s
  @comments_content ||= ''
  puts @comments_content
  image_links = [@today_lifelog.calender.to_s, @today_lifelog.screen_time.to_s]

  @images = ['calender.jpg', 'screen_time.jpg']

  @i = -1
  image_links.size.times do
    File.open(@images[@i + 1], 'wb') do |file|
      URI.open(image_links[@i + 1]) do |png|
        file.puts png.read
      end
    end
    @i += 1
  end
  sleep 30
  begin
    @twitter_client.update_with_media(@comments_content, @images, options = { in_reply_to_status_id: @tweets[0].id })
  rescue StandardError
    sleep 20
    retry
  end
  @images.each do |image|
    File.delete(image)
  end
end

# def get_lifelog
#   user = User.find_by(admin: true)
#   @lifelog_id = user.user_setting.post_lifelog_id
#   if @lifelog_id.nil?
#     puts 'nil'
#     @today_date = Date.today.prev_day(user.user_setting.tweet_lifelog_date)
#   else
#     lifelog = Lifelog.find(@lifelog_id)
#     @today_date = lifelog.log_date
#   end

#   @today_lifelog = user.lifelogs.find_by(log_date: @today_date)
# end

def time_card_upload
  p 'time cards content processing'
  my_twitter_user_id = '3223240382'.to_i
  @twitter_client = nil
  @twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
  p 'ここまできた'
  @tweets = @twitter_client.user_timeline(user_id: my_twitter_user_id, count: 1, exclude_replies: false, include_rts: false,
                                          contributor_details: false, result_type: 'recent', locale: 'ja', tweet_mode: 'extended')

  # calenderとscreen_timeのurlを取得してhashに格納
  @image = 'upload.jpg'
  p @content
  sleep 30
  begin
    @twitter_client.update_with_media(@content, @image, options = { in_reply_to_status_id: @tweets[0].id })
  rescue StandardError
    sleep 20
    retry
  end
  File.delete(@image)
  sleep 2
  @today_lifelog[:tweeted?] = true
  @today_lifelog.save
end

def create_content
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

  @content = '今日の朝のタイムカード記録！！' + "\n" + recoded_location + "\n" + be_on_time + gap_on_str + "\n" + gap_min_on_str + "\n" + tomorrow_tgt

  puts @content
end
