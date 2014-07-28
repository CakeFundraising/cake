CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS', 
    :aws_access_key_id      => 'AKIAJ4FFENMWMH356KOA',
    :aws_secret_access_key  => '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',
  }

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
  elsif Rails.env.development?
    config.storage = :file
  else
    config.storage = :fog
  end
 
  config.fog_directory = 'cakefundraising'
end