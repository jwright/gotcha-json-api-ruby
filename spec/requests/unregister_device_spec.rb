require "request_helper"

RSpec.describe "DELETE /api/devices/:token" do
  let(:device) { create :device, player: player, token: token }
  let(:player) { create :player, :authorized }
  let(:token) { "DEVICE_001" }

  context "with a valid request" do
    it "returns a no content status" do
      delete "/api/devices/#{token}", headers: valid_authed_headers

      expect(response).to be_no_content
    end
  end
end
