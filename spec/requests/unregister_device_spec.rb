require "request_helper"

RSpec.describe "DELETE /api/devices/:token" do
  let!(:device) { create :device, player: player, token: token }
  let(:player) { create :player, :authorized }
  let(:token) { "DEVICE_001" }

  context "with a valid request" do
    it "returns a no content status" do
      delete "/api/devices/#{token}", headers: valid_authed_headers

      expect(response).to be_no_content
    end

    it "deletes the device" do
      expect { delete "/api/devices/#{token}", headers: valid_authed_headers }.to \
        change { Device.count }.by -1
      expect(Device.find_by_token(token)).to be_nil
    end
  end

  context "with a device id that does not exist" do
    it "returns a not found status" do
      delete "/api/devices/blah", headers: valid_authed_headers

      expect(response).to be_not_found
    end
  end
end
