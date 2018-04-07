require "request_helper"

RSpec.describe "POST /api/matches/:id/capture" do
  let(:arena) { create :arena }
  let(:match) { create :match, arena: arena, seeker: player }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/matches/#{match.id}/capture" }

  context "with a valid request" do
    it "returns an ok status" do
      post url, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "marks the match as found" do
      post url, headers: valid_authed_headers

      expect(match.reload).to be_found
    end

    xit "creates a new match for the seeker"
    xit "creates a new match for the opponent"

    it "returns the json representation of the match" do
      post url, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "match"
      expect(json_response[:data][:id]).to eq match.id.to_s
    end
  end

  context "with a match that does not exist" do
    it "returns a not found status" do
      post "/api/matches/-1/capture", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors]).to include "Match with id -1 not found"
    end
  end

  context "with a match that is not open" do
    let(:match) { create :match, :ignored, arena: arena, seeker: player }

    it "returns an unprocessable entity status" do
      post url, headers: valid_authed_headers

      expect(response.status).to eq 422
      expect(json_response[:errors]).to include "Match is not open"
    end
  end

  context "with an arena that the player is not playing in" do
    let(:match) { create :match }

    it "returns a not authorized status" do
      post url, headers: valid_authed_headers

      expect(response).to be_unauthorized
      expect(json_response[:errors]).to include "Not authorized to play in that Match"
    end
  end
end
