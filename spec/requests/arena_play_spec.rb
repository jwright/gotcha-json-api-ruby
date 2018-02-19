require "request_helper"

RSpec.describe "POST /api/arenas/:id/play" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized }
  let(:valid_parameters) { {}.to_json }

  context "with a valid request" do
    let(:player_arena) { PlayerArena.unscoped.last }

    it "returns an ok status" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "joins the player to the arena" do
      expect { post "/api/arenas/#{arena.id}/play", params: valid_parameters,
               headers: valid_authed_headers }.to \
               change { PlayerArena.count }.by 1
      expect(player_arena.joined_at).to be_within(1.second).of(DateTime.now)
      expect(player_arena.player).to eq player
      expect(player_arena.arena).to eq arena
    end

    it "returns a JSON representation of the player arena" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "player_arena"
      expect(json_response[:data][:id]).to eq player_arena.id.to_s
    end
  end
end
