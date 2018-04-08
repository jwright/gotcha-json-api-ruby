require "request_helper"

RSpec.describe "GET /api/arenas/:id/scores" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/arenas/#{arena.id}/scores" }

  context "with a valid request" do
    let!(:score1) { create :score, arena: arena, player: player, points: 1 }
    let!(:score2) { create :score, arena: arena, player: player, points: 1 }

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
  end
end
