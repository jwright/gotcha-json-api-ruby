require "request_helper"

RSpec.describe "POST /api/arenas/:id/play" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized }
  let(:valid_parameters) { {}.to_json }

  context "with a valid request" do
    let(:player_arena) { PlayerArena.unscoped.last }

    it "returns a created status" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(response).to be_created
    end

    it "joins the player to the arena" do
      expect { post "/api/arenas/#{arena.id}/play", params: valid_parameters,
               headers: valid_authed_headers }.to \
               change { PlayerArena.count }.by 1
      expect(player_arena.joined_at).to be_within(1.second).of(DateTime.now)
      expect(player_arena.player).to eq player
      expect(player_arena.arena).to eq arena
    end

    it "runs a job to try and find a match for the player and arena" do
      expect { post "/api/arenas/#{arena.id}/play", params: valid_parameters,
               headers: valid_authed_headers }.to \
               have_enqueued_job(MakeMatchJob).with(player.id, arena.id)
    end

    it "returns a JSON representation of the player arena" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "player_arena"
      expect(json_response[:data][:id]).to eq player_arena.id.to_s
    end
  end

  context "with an arena already joined" do
    let!(:player_arena) { create :player_arena, player: player, arena: arena }

    it "returns an ok status" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "does not create a new player arena" do
      expect { post "/api/arenas/1234/play", params: valid_parameters,
               headers: valid_authed_headers }.to_not change { PlayerArena.count }
    end
  end

  context "with an invalid arena id" do
    it "returns a not found status" do
      post "/api/arenas/1234/play", params: valid_parameters,
                                    headers: valid_authed_headers

      expect(response.status).to eq 404
      expect(json_response[:errors]).to include "Arena with id 1234 not found"
    end

    it "does not create the player arena" do
      expect { post "/api/arenas/1234/play", params: valid_parameters,
               headers: valid_authed_headers }.to_not change { PlayerArena.count }
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                             headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                             headers: valid_headers.merge(headers)
      end
    end
  end
end
