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

    it "creates a new match for the seeker" do
      expect { post url, headers: valid_authed_headers }.to \
        have_enqueued_job(MakeMatchJob).with(match.seeker_id, match.arena_id)
    end

    it "creates a new match for the opponent" do
      expect { post url, headers: valid_authed_headers }.to \
        have_enqueued_job(MakeMatchJob).with(match.opponent_id, match.arena_id)
    end

    it "returns the json representation of the match" do
      post url, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "match"
      expect(json_response[:data][:id]).to eq match.id.to_s
    end
  end

  context "with a match that does not exist" do
    it "returns a not found status" do
      post "/api/matches/-1/capture", headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors].first[:detail]).to \
        eq "Match with id -1 not found"
    end
  end

  context "with a match that is not open" do
    let(:match) { create :match, :ignored, arena: arena, seeker: player }

    it "returns an unprocessable entity status" do
      post url, headers: valid_authed_headers

      expect(response.status).to eq 422
      expect(json_response[:errors]).to include "Match is not open"
    end
  end

  context "with an arena that the player is not playing in" do
    let(:match) { create :match }

    it "returns a not authorized status" do
      post url, headers: valid_authed_headers

      expect(response).to be_unauthorized
      expect(json_response[:errors].first[:detail]).to \
        eq "Not authorized to play in that Match"
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post url, headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post url, headers: valid_headers.merge(headers)
      end
    end
  end
end
