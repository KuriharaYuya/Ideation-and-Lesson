# unless Rails.env.development? || Rails.env.test?
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAVJLWI5AJTMP6NJXB',
    aws_secret_access_key: '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',
    region: 'ap-northeast-1'
  }

  config.fog_directory = 'myvideoresource'
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.asset_host = 'https://myvideoresource.s3.amazonaws.com'
  config.fog_public = true
end
# end
