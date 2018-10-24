CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Rails.application.secrets.aws[:access_key_id],
    :aws_secret_access_key  => Rails.application.secrets.aws[:secret_access_key],
    :region                 => 'ap-northeast-1',
    :path_style             => true,
  }

  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'public, max-age=86400'}
  config.fog_directory = 'mecabl'
  config.asset_host = "https://s3-ap-northeast-1.amazonaws.com/mecabl"
end
