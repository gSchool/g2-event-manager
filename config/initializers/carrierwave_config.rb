if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ID'] || 'fake',
      :aws_secret_access_key  => ENV['AWS_KEY'] || 'fake',
    }
    config.fog_directory  = ENV['AWS_DIR'] || 'fake'
  end
end