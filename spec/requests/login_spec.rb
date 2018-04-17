require "request_helper"

RSpec.describe "POST /api/sessions" do
  let(:password) { "p@ssword" }
  let(:player) { create :player, password: password }
  let(:valid_parameters) do
    {
      data: {
        type: "sessions",
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

    it "generates an api key for the player" do
      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(player.reload.api_key).to_not be_blank
    end

    it "does not regenerate the api key for the user if one already exists" do
      api_key = "API_KEY"
      player.update_attributes(api_key: api_key)

      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(player.reload.api_key).to eq api_key
    end

    it "returns the json representation of a player" do
      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(json_response[:data][:type]).to eq "players"
      expect(json_response[:data][:id]).to eq player.id.to_s
    end
  end

  context "with invalid email address" do
    let(:parameters) do
      {
        data: {
          type: "sessions",
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
      expect(json_response[:errors].first[:detail]).to \
        include "Invalid email address or password"
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post "/api/sessions", params: valid_parameters,
                              headers: valid_headers.merge(headers)
      end
    end
  end
end
