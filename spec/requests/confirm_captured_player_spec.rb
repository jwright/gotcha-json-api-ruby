require "request_helper"

RSpec.describe "POST /api/matches/:id/captured" do
  let(:arena) { create :arena }
  let(:match) { create :match, :pending, arena: arena, seeker: player }
  let(:player) { create :player, :authorized, arenas: [arena] }
  let(:url) { "/api/matches/#{match.id}/captured" }
  let(:valid_parameters) do
    {
      data: {
        type: "match",
        attributes: {
          confirmation_code: match.confirmation_code
        }
      }
    }.to_json
  end

  context "with a valid request" do
    it "returns an ok status" do
      post url, params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "marks the match as found" do
      post url, params: valid_parameters, headers: valid_authed_headers

      expect(match.reload).to be_found
    end

    it "creates a new match for the seeker" do
      expect { post url, params: valid_parameters,
                         headers: valid_authed_headers }.to \
        have_enqueued_job(MakeMatchJob).with(match.seeker_id, match.arena_id)
    end

    it "creates a new match for the opponent" do
      expect { post url, params: valid_parameters,
                         headers: valid_authed_headers }.to \
        have_enqueued_job(MakeMatchJob).with(match.opponent_id, match.arena_id)
    end

    it "returns the json representation of the match" do
      post url, params: valid_parameters, headers: valid_authed_headers

      expect(json_response[:data][:type]).to eq "match"
      expect(json_response[:data][:id]).to eq match.id.to_s
      expect(json_response[:data][:attributes][:confirmation_code]).to \
        be_nil
    end
  end
end
