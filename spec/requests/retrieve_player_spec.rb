require "request_helper"

RSpec.describe "GET /api/players/:id" do
  let(:player) { create :player, :authorized }
  let(:url) { "/api/players/#{player.id}" }

  context "with a valid request" do
    it "returns an ok status" do
      get url, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "returns the json representation of a player" do
      get url, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "player"
      expect(json_response[:data][:id]).to eq player.id.to_s
    end

    it "does not include the api key in the json representaiton" do
      get url, headers: valid_authed_headers

      expect(json_response[:data][:attributes]).to_not include :api_key
    end
  end

  context "with an invalid player id" do
    it "returns a not found status" do
      get "/api/players/1234", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors]).to include "Player with id 1234 not found"
    end
  end

  context "with a player that the player cannot read" do
    let(:someone_else) { create :player }

    it "returns an unauthorized status" do
      get "/api/players/#{someone_else.id}", headers: valid_authed_headers

      expect(response).to be_unauthorized
      expect(json_response[:errors]).to include "Player could not be found"
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        get url, headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        get url, headers: valid_authed_headers.merge(headers)
      end
    end
  end
end
