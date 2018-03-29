require "request_helper"

RSpec.describe "POST /api/matches" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:valid_parameters) do
    {
      data: {
        type: "match",
        attributes: {
          arena_id: arena.id
        }
      }
    }.to_json
  end

  context "with a valid request" do
    context "with an available opponent" do
      let(:match) { Match.unscoped.last }
      let!(:opponent) { create :player, arenas: [arena] }

      it "returns a created status" do
        post "/api/matches", params: valid_parameters, headers: valid_authed_headers

        expect(response).to be_created
      end

      it "creates a match between the two players" do
        expect { post "/api/matches", params: valid_parameters,
                                      headers: valid_authed_headers }.to \
          change { Match.count }.by 1

        expect(match.arena).to eq arena
        expect(match.seeker).to eq player
        expect(match.opponent).to eq opponent
      end

      it "returns the json representation of the match" do
        post "/api/matches", params: valid_parameters, headers: valid_authed_headers

        expect(json_response[:data][:type]).to eq "match"
        expect(json_response[:data][:id]).to eq match.id.to_s
      end
    end

    context "without an available opponent" do
      it "returns a no content status" do
        post "/api/matches", params: valid_parameters, headers: valid_authed_headers

        expect(response).to be_no_content
      end

      it "does not create a match" do
        expect { post "/api/matches", params: valid_parameters,
                                      headers: valid_authed_headers }.to_not \
          change { Match.count }
      end
    end
  end

  context "with an arena that the player is not playing in" do
  end

  context "without an arena" do
    let(:parameters) do
      {
        data: {
          type: "match",
          attributes: {
            arena_id: -1
          }
        }
      }.to_json
    end

    it "returns a not found status" do
      post "/api/matches", params: parameters, headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors]).to include "Arena with id -1 not found"
    end
  end
end
