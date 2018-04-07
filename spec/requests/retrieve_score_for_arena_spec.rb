require "request_helper"

RSpec.describe "GET /api/arenas/:id/score" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/arenas/#{arena.id}/score" }

  context "with a valid request" do
    it "returns an ok status" do
      get url, headers: valid_authed_headers

      expect(response).to be_ok
    end
  end
end
