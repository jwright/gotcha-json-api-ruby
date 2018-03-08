require "request_helper"

RSpec.describe "POST /api/sessions" do
  let(:password) { "p@ssword" }
  let(:player) { create :player, password: password }
  let(:valid_parameters) do
    {
      data: {
        type: "player",
        attributes: {
          email_address: player.email_address,
          password: password
        }
      }
    }.to_json
  end

  context "with a valid request" do
    it "returns an ok status" do
      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(response).to be_ok
    end

    it "returns the json representation of a player" do
      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(json_response[:data][:type]).to eq "player"
      expect(json_response[:data][:id]).to eq player.id.to_s
    end
  end

  context "with invalid email address" do
    let(:parameters) do
      {
        data: {
          attributes: {
            email_address: "someone-else@example.com",
            password: password
          }
        }
      }.to_json
    end

    it "returns an unauthorized status" do
      post "/api/sessions", params: parameters, headers: valid_headers

      expect(response).to have_http_status(:unauthorized)
      expect(json_response[:errors]).to include "Not authorized"
    end
  end
end
