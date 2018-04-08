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
      get url, headers: valid_headers

      expect(json_response[:data][:type]).to eq "player"
      expect(json_response[:data][:id]).to eq player.id.to_s
    end
  end
end
