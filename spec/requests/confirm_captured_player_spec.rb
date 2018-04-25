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

    it "processes the successful match" do
      expect { post url, params: valid_parameters,
                         headers: valid_authed_headers }.to \
        have_enqueued_job(SuccessfulCaptureJob).with(match.id)
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

  context "with a match that does not exist" do
    it "returns a not found status" do
      post "/api/matches/-1/captured", params: valid_parameters,
                                       headers: valid_authed_headers

      expect(response).to be_not_found
      expect(json_response[:errors].first[:detail]).to \
        eq "Match with id -1 not found"
    end
  end

  context "with a match that is not pending" do
    let(:match) { create :match, arena: arena, seeker: player }

    it "returns a pre-condition failed status" do
      post url, params: valid_parameters, headers: valid_authed_headers

      expect(response.status).to eq 412
      expect(json_response[:errors].map { |error| error[:detail] }).to \
        include "Match is not pending"
    end
  end

  context "with a confirmation code that does not match" do
    let(:parameters) do
      {
        data: {
          type: "match",
          attributes: {
            confirmation_code: "blah"
          }
        }
      }.to_json
    end

    it "returns a bad request status" do
      post url, params: parameters, headers: valid_authed_headers

      expect(response).to be_bad_request
      expect(json_response[:errors].map { |error| error[:detail] }).to \
        include "Confirmation code does not match"
    end
  end

  context "with an arena that the player is not playing in" do
    let(:match) { create :match }

    it "returns a not authorized status" do
      post url, params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_unauthorized
      expect(json_response[:errors].first[:detail]).to \
        eq "Not authorized to play in that Match"
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        post url, params: valid_parameters,
                  headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        post url, params: valid_parameters,
                  headers: valid_authed_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request requiring the correct type" do
    let(:make_request) do
      -> (params) do
        post url, params: params, headers: valid_authed_headers
      end
    end
  end
end
