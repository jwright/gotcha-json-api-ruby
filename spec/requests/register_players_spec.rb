require "rails_helper"

RSpec.describe "POST /api/players" do
  let(:avatar) { "THIS NEEDS TO BE A BASE64 STRING" }
  let(:json_response) { JSON.parse(response.body).deep_symbolize_keys }
  let(:valid_headers) do
    {
      "Accept": JSONAPI::MEDIA_TYPE,
      "Content-type": JSONAPI::MEDIA_TYPE
    }
  end
  let(:valid_parameters) do
    {
      data: {
        type: "player",
        attributes: {
          first_name: "Jimmy",
          last_name: "Page",
          email_address: "jimmy@example.com",
          password: "p@ssword",
          avatar: avatar
        }
      }
    }.to_json
  end

  context "with a valid request" do
    let(:player) { Player.unscoped.last }

    it "returns the correct status" do
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
      expect(json_response[:errors]).to \
        eq ["param is missing or the value is empty: attributes"]
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

  context "without a correct accept header" do
    it "returns a not acceptable status" do
      post "/api/players", params: valid_parameters,
        headers: valid_headers.merge("Accept": "application/json")

      expect(response).to have_http_status(:not_acceptable)
    end
  end

  context "without a correct content type header" do
    it "returns an unsupported media type status" do
      post "/api/players", params: valid_parameters,
        headers: valid_headers.merge("Content-type": "application/json")

      expect(response).to have_http_status(:unsupported_media_type)
    end
  end
end
