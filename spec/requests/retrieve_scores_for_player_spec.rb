require "request_helper"

RSpec.describe "GET /api/scores?filter[player]=:player_id" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/scores?filter[player]=#{player.id}" }

  context "with a valid request" do
    let!(:score1) { create :score, arena: arena, player: player, points: 1 }
    let!(:score2) { create :score, arena: arena, player: player, points: 1 }
    let!(:score3) { create :score, arena: arena, points: 1 }

    it "returns an ok status" do
      get url, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "returns a json representation of all the scores" do
      get url, headers: valid_authed_headers

      expect(json_response[:data].length).to eq 2
      expect(json_response[:data].map { |score| score[:id].to_i }).to \
        match_array [score1.id, score2.id]
    end

    it "includes the meta-data for the placement in the arena" do
      get url, headers: valid_authed_headers

      expect(json_response[:meta][:placement]).to eq "1st"
    end
  end
end
