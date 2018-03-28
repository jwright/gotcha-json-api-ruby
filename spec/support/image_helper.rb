require "base64_image"

module ImageHelper
  def base64_encode(file_fixture)
    Base64Image.encode file_fixture
  end
end
