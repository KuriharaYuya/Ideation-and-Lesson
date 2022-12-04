@twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

@tweets = @twitter_client.user_timeline(user_id: my_twitter_user_id, count: 1, exclude_replies: false, include_rts: false,
                                        contributor_details: false, result_type: 'recent', locale: 'ja', tweet_mode: 'extended')

@twitter_client.update_with_media(@comments_content, @images,
                                  options = { in_reply_to_status_id: @tweets[0].id })
