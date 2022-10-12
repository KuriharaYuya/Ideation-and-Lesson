desc 'twitter test'
task twitter_mov_expired_test: :environment do
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
  url = 'https://myvideoresource.s3.ap-northeast-1.amazonaws.com/uploads/micropost/video/8/Screen_Recording_2022-10-10_at_20.26.41.mp4'
  tgt_file = 'test.mp4'
  File.open(tgt_file, 'wb') do |file|
    URI.open(url) do |movie|
      file.puts movie.read
    end
  end
  mov = File.new(open(tgt_file))
  init_request = Twitter::REST::Request.new(twitter_client, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                                            { command: 'INIT', total_bytes: mov.size, media_type: 'video/mp4', media_category: 'tweet_video' }).perform
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
  begin
    restore
    twitter_client.update(
      "#{'test' * 15}" + @tweet_content, media_ids: init_request[:media_id]
    )
  rescue Twitter::Error::BadRequest
    sleep 5
    @f += 1
    @twitter_client = twitter_client
    @init = init_request[:media_id]
    begin
      @twitter_client.update(
        "#{'test' * 15}" + @tweet_content, media_ids: @init
      )
    rescue Twitter::Error::BadRequest
      unless @f == 30
        sleep 10
        retry
      end
    end
  rescue Twitter::Error::Forbidden
    @wrong_times = 1
    retry
  end
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
  @today_microposts.each do |micropost|
    next unless micropost.engagement_status == '完了'

    @micropost_consuming_sum.push(micropost.consuming_minutes)
    str = "#{@i}限目: #{micropost.title} #{to_HH_MM(micropost.consuming_minutes)}\n"
    @tweet_micropost_logs.push(str)
    @timelapse_timetable_numb = @i
    @i += 1
  end
  @micropost_consuming_sum = @micropost_consuming_sum.sum

  @tweet_microposts = []
  if @wrong_times.nil?
    @tweet_micropost_logs.each do |log|
      @tweet_microposts.push(log)
    end
  elsif @wrong_times.present?
    @upto = @tweet_micropost_logs.size - 1
    @f = 1
    @tweet_micropost_logs.each do |log|
      break if @upto == @f

      @tweet_microposts.push(log)
    end
  end

  @tweet_microposts = @tweet_microposts.join

  # からのjoinで改行させて結合
  tweet_title = "#{@today_lifelog.log_date}の記録🥺\n"
  tweet_lifelog_sum = "合計で#{to_HH_MM(@micropost_consuming_sum)}!明日も頑張ります！"
  #   tweet_footer = '今日の'
  tweet_video_desc = "↓は#{@timelapse_timetable_numb}限目の様子です!\n詳しくはurlを確認!https://twitter.com/asukakiraran"
  tweet_hashtag = '#test_明日花キララlog'
  @tweet_content = tweet_title + @tweet_microposts + tweet_lifelog_sum + tweet_video_desc + "\n" + tweet_hashtag
end

def set_lifelogs
  today_date = Date.today
  @today_lifelog = Lifelog.find_by(log_date: today_date)
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
