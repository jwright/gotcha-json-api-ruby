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

    it "returns the json representation of the match" do
      post url, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "match"
      expect(json_response[:data][:id]).to eq match.id.to_s
    end
  end

  context "with a match that does not exist" do
    xit "returns a not found status" do
    end
  end

  context "with a match that is not open" do
    xit "returns an bad request status"
  end

  context "with an arena that the player is not playing in" do
    xit "returns a not authorized status" do
    end
  end
end
