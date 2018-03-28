class AvatarUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(jpg jpeg gif png tiff)
  end

  def size_range
    1..1.megabyte
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
