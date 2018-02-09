require "rails_helper"

RSpec.describe "POST /api/players" do
  let(:json_response) { JSON.parse(response.body).deep_symbolize_keys }

  context "with a valid request" do
    let(:avatar) { "THIS NEEDS TO BE A BASE64 STRING" }
    let(:parameters) do
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
      }
    end
    let(:player) { Player.unscoped.last }

    it "returns the correct status" do
      post "/api/players", params: parameters

      expect(response).to have_http_status(:created)
    end

    it "creates a player" do
      expect { post "/api/players", params: parameters }.to \
        change { Player.count }.by 1

      expect(player.email_address).to eq "jimmy@example.com"
    end

    it "returns the json representation of a player" do
      post "/api/players", params: parameters

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
      }
    end

    it "returns a bad request status" do
      post "/api/players", params: parameters

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
      }
    end

    it "returns an unprocessable entity status" do
      post "/api/players", params: parameters

      expect(response.status).to eq 422
      expect(json_response[:errors]).to include "Password can't be blank"
    end

    it "does not create the player" do
      expect { post "/api/players", params: parameters }.to_not \
        change { Player.count }
    end
  end

  context "without a correct json content type" do
    xit "returns a not found status"
  end
end
