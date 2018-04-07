require "request_helper"

RSpec.describe "POST /api/arenas/:id/leave" do
  let(:arena) { create :arena }
  let!(:player) { create :player, :authorized, arenas: [arena] }

  context "with a valid request" do
    it "returns a no content status" do
      post "/api/arenas/#{arena.id}/leave", headers: valid_authed_headers

      expect(response).to be_no_content
    end

    it "removes the player from the arena" do
      expect { post "/api/arenas/#{arena.id}/leave",
               headers: valid_authed_headers }.to \
               change { PlayerArena.count }.by -1
      expect(player.reload.arenas).to be_empty
    end
  end
end
