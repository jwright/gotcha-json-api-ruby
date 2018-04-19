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

    it "associates the device with the current player" do
      post "/api/devices", params: valid_parameters, headers: valid_authed_headers

      expect(device.player).to eq player
    end

    it "returns a json representation of a device" do
      post "/api/devices", params: valid_parameters, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "device"
      expect(json_response[:data][:id]).to eq device.id.to_s
    end
  end

  context "with a device already registered" do
    let!(:device) { create :device, player: player, token: token }

    it "returns an ok status" do
      post "/api/devices", params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "does not create a new device" do
      expect { post "/api/devices", params: valid_parameters,
               headers: valid_authed_headers }.to_not change { Device.count }
    end
  end

  context "with an incorrect json payload" do
    let(:parameters) do
      {
        data: {
          type: "device",
          token: token
        }
      }.to_json
    end

    it "returns a bad request status" do
      post "/api/devices", params: parameters, headers: valid_authed_headers

      expect(response).to be_bad_request
      expect(json_response[:errors]).to \
        eq ["param is missing or the value is empty: attributes"]
    end
  end

  context "with an incorrect type specified" do
    let(:parameters) do
      {
        data: {
          type: "blah",
          attributes: {
            token: token
          }
        }
      }.to_json
    end

    it "returns a bad request status" do
      post "/api/devices", params: parameters, headers: valid_authed_headers

      expect(response).to be_bad_request
      expect(json_response[:errors]).to \
        eq ["blah is not a valid type for this operation"]
    end
  end

  context "without a type specified" do
    it "returns a bad request status" do
      post "/api/devices", params: { data: {}}, headers: valid_authed_headers

      expect(response).to be_bad_request
      expect(json_response[:errors]).to \
        eq ["param is missing or the value is empty: type"]
    end
  end

  context "with an invalid attribute" do
    let(:parameters) do
      {
        data: {
          type: "device",
          attributes: {
            token: "",
          }
        }
      }.to_json
    end

    it "returns an unprocessable entity status" do
      post "/api/devices", params: parameters, headers: valid_authed_headers

      expect(response.status).to eq 422
      expect(json_response[:errors]).to include "Token can't be blank"
    end

    it "does not create the device" do
      expect { post "/api/devices", params: parameters,
                                    headers: valid_authed_headers }.to_not \
        change { Device.count }
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post "/api/devices", params: valid_parameters,
                             headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post "/api/devices", params: valid_parameters,
                             headers: valid_authed_headers.merge(headers)
      end
    end
  end
end
