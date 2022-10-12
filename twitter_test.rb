# https://developer.twitter.com/apps
require 'twitter'
# require 'json'

def mov_upload
  twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'dARw8BZxBlgqLdrXmUdLP5HL4'
    config.consumer_secret     = 'gZ9cLoaSU3ToBlHuTkg58sQDfs5fGfnpPiRhB0a8CJOM2npnfY'
    config.access_token        = '3223240382-TIOkEDOw6iWcDoVgLiNHejAKZANwTefDJMO8Fwx'
    config.access_token_secret = '2Bo0HU4l3YNkX42IxvtnzjB4DOtOxXkHnFSvNxQ0d5xgc'
  end
  mov = File.new(open('black_pink.mp4'))
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
    twitter_client.update(
      'TEST#5: Uploading over 30MB mp4 file automatically by Rails scripts. Test file is uploaded from my local storage.', media_ids: init_request[:media_id]
    )
  rescue Twitter::Error::BadRequest
    sleep 5
    @f += 1
    retry unless @f == 30
  end
end

def image_upload_by_aws
  require 'open-uri'
  twitter_client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'dARw8BZxBlgqLdrXmUdLP5HL4'
    config.consumer_secret     = 'gZ9cLoaSU3ToBlHuTkg58sQDfs5fGfnpPiRhB0a8CJOM2npnfY'
    config.access_token        = '3223240382-TIOkEDOw6iWcDoVgLiNHejAKZANwTefDJMO8Fwx'
    config.access_token_secret = '2Bo0HU4l3YNkX42IxvtnzjB4DOtOxXkHnFSvNxQ0d5xgc'
  end

  url = 'https://i.ytimg.com/vi/YTEjbYmpj5s/maxresdefault.jpg'
  tgt_file = 'test.jpg'
  File.open(tgt_file, 'wb') do |file|
    URI.open(url) do |img|
      file.puts img.read
    end
  end
  images = []
  images << File.new(tgt_file)
  twitter_client.update_with_media(
    'TEST#6: Image uploading automatically through AWS S3 cloud storage.Then local ref_file would be deleted by Rails script. ', images
  )
  sleep 5
  File.delete(tgt_file)
  p 'Process completed'
end
# t = TwitterAPI::Client.new({
#                              consumer_key: 'dARw8BZxBlgqLdrXmUdLP5HL4',
#                              consumer_secret: 'gZ9cLoaSU3ToBlHuTkg58sQDfs5fGfnpPiRhB0a8CJOM2npnfY',
#                              token: '3223240382-TIOkEDOw6iWcDoVgLiNHejAKZANwTefDJMO8Fwx',
#                              token_secret: '2Bo0HU4l3YNkX42IxvtnzjB4DOtOxXkHnFSvNxQ0d5xgc'
#                            })

# client.update(' TEST#1: Automation_post_test from my Rails App with twitter API. the test  only for text.')
image_upload_by_aws
