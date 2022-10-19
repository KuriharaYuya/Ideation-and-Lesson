# unless Rails.env.development? || Rails.env.test?
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: 'ap-northeast-1'
  }
  config.storage :fog
  config.fog_provider = 'fog/aws'
  if Rails.env.development?
    config.fog_directory = 'myvideoresource'
    config.asset_host = 'https://myvideoresource.s3.amazonaws.com'
  elsif Rails.env.test?
    config.fog_directory = 'yuyaassetresroucestest'
    config.asset_host = 'https://yuyaassetresroucestest.s3.amazonaws.com'
  elsif Rails.env.production?
    config.fog_directory = 'yuyaassetresroucesprod'
    config.asset_host = 'https://yuyaassetresroucesprod.s3.amazonaws.com'
  end
  config.fog_public = true
end
# end
