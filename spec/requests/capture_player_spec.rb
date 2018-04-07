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
  end
end
