require "rails_helper"
require "base64_image"

RSpec.describe Base64Image do
  include ImageHelper

  let(:image) { file_fixture("led_zeppelin.jpg") }

  describe "#decode" do
    let(:base64_image) { base64_encode(image) }

    it "returns IO with decoded data" do
      result = described_class.decode(base64_image)

      expect(result.first).to be_kind_of StringIO
    end

    it "returns the filename with the extension" do
      result = described_class.decode(base64_image, "blah")

      expect(result.second).to eq "blah.jpeg"
    end

    it "returns the content type" do
      result = described_class.decode(base64_image)

      expect(result.last).to eq "image/jpeg"
    end
  end

  describe "#encode" do
    it "adds the mime type" do
      result = described_class.encode(image)

      expect(result).to start_with "data:image/jpeg"
    end
  end
end
