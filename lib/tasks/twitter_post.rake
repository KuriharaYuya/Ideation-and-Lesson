desc 'twitter movie test'
task twitter_mov_test: :environment do
  # ここから処理を書いていく
  require 'twitter'
  # require 'json'
  set_lifelogs
  mov_upload
end
def mov_upload
  twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'dARw8BZxBlgqLdrXmUdLP5HL4'
    config.consumer_secret     = 'gZ9cLoaSU3ToBlHuTkg58sQDfs5fGfnpPiRhB0a8CJOM2npnfY'
    config.access_token        = '3223240382-TIOkEDOw6iWcDoVgLiNHejAKZANwTefDJMO8Fwx'
    config.access_token_secret = '2Bo0HU4l3YNkX42IxvtnzjB4DOtOxXkHnFSvNxQ0d5xgc'
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
  init_request = Twitter::REST::Request.new(twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                                            { command: 'INIT', total_bytes: mov.size, media_type: 'video/mov', media_category: 'tweet_video' }).perform
  p 'init is completed'
  @i = 1
  until mov.eof?
    base64_chunk = Base64.encode64(mov.read(5_000_000))
    base64_chunk.delete("\n")
    seg ||= -1
    p @i
    @i += 1
    Twitter::REST::Request.new(twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                               { command: 'APPEND', media_id: init_request[:media_id], media_data: base64_chunk, segment_index: seg += 1, key: :media }).perform
  end
  p 'append is completed'
  mov.close
  Twitter::REST::Request.new(twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                             { command: 'FINALIZE', media_id: init_request[:media_id] }).perform
  p 'F is completed'
  @f = 1
  restore
  begin
    puts @tweet_content
    p @tweet_content.length
    twitter_client.update(
      @tweet_content, media_ids: init_request[:media_id]
    )
  rescue Twitter::Error::BadRequest
    sleep 10
    @f += 1
    @twitter_client = twitter_client
    @init = init_request[:media_id]
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
  twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'dARw8BZxBlgqLdrXmUdLP5HL4'
    config.consumer_secret     = 'gZ9cLoaSU3ToBlHuTkg58sQDfs5fGfnpPiRhB0a8CJOM2npnfY'
    config.access_token        = '3223240382-TIOkEDOw6iWcDoVgLiNHejAKZANwTefDJMO8Fwx'
    config.access_token_secret = '2Bo0HU4l3YNkX42IxvtnzjB4DOtOxXkHnFSvNxQ0d5xgc'
  end

  # ================================================

  @tweet_micropost_logs = []
  @micropost_consuming_sum = []
  # 配列にして、要素ごとに説明を入れる
  @i = 1
  @today_microposts = @today_lifelog.microposts.order(start_datetime: :asc)
  @today_microposts.each do |micropost|
    next unless micropost.engagement_status == '完了'
    p micropost.title
    @micropost_consuming_sum.push(micropost.consuming_minutes)
    str = "#{@i}限目: #{micropost.title} #{to_HH_MM(micropost.consuming_minutes)}\n"
    @tweet_micropost_logs.push(str)
    @timelapse_timetable_numb = @i
    @i += 1
  end
  @micropost_consuming_sum = @micropost_consuming_sum.sum

  @tweet_microposts ||= []
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
    summed_microposts = @today_microposts.reverse[0..(summed_microposts_numb -1)]

    @summed_microposts_consuming_minutes = 1
    summed_microposts.each do |micropost|
      @summed_microposts_consuming_minutes += micropost.consuming_minutes
    end
    @summed_microposts_consuming_minutes = @summed_microposts_consuming_minutes - 1
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
  tweet_title = "#{@today_lifelog.log_date}の記録🥺\n"
  tweet_lifelog_sum = "合計で#{to_HH_MM(@micropost_consuming_sum)}!明日も頑張ります！"
  tweet_video_desc = '詳しくはurlを確認!https://twitter.com/asukakiraran'
  tweet_hashtag = '#testだよ！明日花キララ日記!'
  @tweet_content = tweet_title + "\n" + @tweet_microposts + tweet_lifelog_sum + "\n" + tweet_video_desc + "\n" + tweet_hashtag + "\n" + "↓は#{@timelapse_timetable_numb}限目の様子です!"
end

def set_lifelogs
  @today_date = Date.yesterday
  @today_lifelog = Lifelog.find_by(log_date: @today_date)
  @today_microposts = @today_lifelog.microposts.order(consuming_minutes: :desc)
  @longest_timelapse_micropost = nil
  @today_microposts.each do |tgt|
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
