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
        post "/api/matches", params: valid_parameters, headers: valid_authed_headers

        expect(match.arena).to eq arena
        expect(match.seeker).to eq player
        expect(match.opponent).to eq opponent
      end
    end
  end
end
