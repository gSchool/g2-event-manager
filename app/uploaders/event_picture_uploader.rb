class EventPictureUploader < CarrierWave::Uploader::Base
  process :resize_to_fit => [200,200]

  version :thumb do
    process :resize_to_fill => [100,100]
  end

  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end