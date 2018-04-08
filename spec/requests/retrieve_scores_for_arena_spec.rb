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

    it "includes meta-data for the total score" do
      get url, headers: valid_authed_headers

      expect(json_response[:meta][:total_points]).to eq 2
    end

    it "includes the meta-data for the placement in the arena" do
      get url, headers: valid_authed_headers

      expect(json_response[:meta][:placement]).to eq "1st"
    end
  end

  context "with an invalid arena id" do
    it "returns a not found status" do
      get "/api/arenas/1234/scores", headers: valid_authed_headers

      expect(response.status).to eq 404
      expect(json_response[:errors]).to include "Arena with id 1234 not found"
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
