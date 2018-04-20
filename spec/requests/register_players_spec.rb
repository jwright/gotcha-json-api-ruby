require "request_helper"

RSpec.describe "POST /api/players" do
  include ImageHelper

  let(:avatar) { file_fixture("led_zeppelin.jpg") }
  let(:base64_avatar) { base64_encode avatar }
  let(:valid_parameters) do
    {
      data: {
        type: "player",
        attributes: {
          name: "Jimmy Page",
          email_address: "jimmy@example.com",
          password: "p@ssword",
          avatar: base64_avatar
        }
      }
    }.to_json
  end

  context "with a valid request" do
    let(:player) { Player.unscoped.last }

    after { player.remove_avatar! }

    it "returns a created status" do
      post "/api/players", params: valid_parameters, headers: valid_headers

      expect(response).to be_created
    end

    it "creates a player" do
      expect { post "/api/players", params: valid_parameters,
                                    headers: valid_headers }.to \
        change { Player.count }.by 1

      expect(player.email_address).to eq "jimmy@example.com"
    end

    it "generates an api key for the player" do
      post "/api/players", params: valid_parameters, headers: valid_headers

      expect(player.api_key).to_not be_blank
    end

    it "returns the json representation of a player" do
      post "/api/players", params: valid_parameters, headers: valid_headers

      expect(json_response[:data][:type]).to eq "player"
      expect(json_response[:data][:id]).to eq player.id.to_s
    end
  end

  context "with an incorrect json payload" do
    let(:parameters) do
      {
        data: {
          type: "player",
          email_address: "jimmy@example.com",
          password: "p@ssword",
        }
      }.to_json
    end

    it "returns a bad request status" do
      post "/api/players", params: parameters, headers: valid_headers

      expect(response).to be_bad_request
      expect(json_response[:errors].first[:detail]).to \
        eq "param is missing or the value is empty: attributes"
    end
  end

  context "with an invalid attribute" do
    let(:parameters) do
      {
        data: {
          type: "player",
          attributes: {
            email_address: "jimmy@example.com",
          }
        }
      }.to_json
    end

    it "returns an unprocessable entity status" do
      post "/api/players", params: parameters, headers: valid_headers

      expect(response.status).to eq 422
      expect(json_response[:errors]).to include "Password can't be blank"
    end

    it "does not create the player" do
      expect { post "/api/players", params: parameters,
                                    headers: valid_headers }.to_not \
        change { Player.count }
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post "/api/players", params: valid_parameters,
                             headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request requiring the correct type" do
    let(:make_request) do
      -> (params) do
        post "/api/players", params: params, headers: valid_headers
      end
    end
  end
end
