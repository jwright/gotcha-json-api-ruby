require "request_helper"

RSpec.describe "GET /api/players/:id" do
  let(:player) { create :player, :authorized }
  let(:url) { "/api/players/#{player.id}" }

  context "with a valid request" do
    it "returns an ok status" do
      get url, headers: valid_authed_headers

      expect(response).to be_ok
    end
  end
end
