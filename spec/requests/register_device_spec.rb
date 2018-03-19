require "request_helper"

RSpec.describe "POST /api/devices" do
  let(:player) { create :player, :authorized }
  let(:token) { "DEVICE_001" }
  let(:valid_parameters) do
    {
      data: {
        type: "device",
        attributes: {
          token: token
        }
      }
    }.to_json
  end

  context "with a valid request" do
    let(:device) { Device.unscoped.last }

    it "returns a created status" do
      post "/api/devices", params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_created
    end

    it "creates the device" do
      expect { post "/api/devices", params: valid_parameters,
                                    headers: valid_authed_headers }.to \
        change { Device.count }.by 1
      expect(device.token).to eq token
    end
  end
end
