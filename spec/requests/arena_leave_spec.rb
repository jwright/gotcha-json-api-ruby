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

  context "with an arena that the player is not in" do
    it "returns a not found status" do
      player.arenas.clear

      post "/api/arenas/#{arena.id}/leave", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors]).to include "Player not found in Arena"
    end
  end

  context "with an invalid arena id" do
    it "returns a not found status" do
      post "/api/arenas/1234/leave", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors]).to include "Arena with id 1234 not found"
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post "/api/arenas/#{arena.id}/leave", headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post "/api/arenas/#{arena.id}/leave", headers: valid_headers.merge(headers)
      end
    end
  end
end
