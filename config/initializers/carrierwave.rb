require "carrierwave"
require "carrierwave/orm/activerecord"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.test?
    config.root = Rails.root
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider:              "AWS",
      aws_access_key_id:     ENV["AWS_ACCESS_KEY"],
      aws_secret_access_key: ENV["AWS_SECRET"]
    }
    config.fog_directory  = "gotcha-api-#{Rails.env}"
  end
end
