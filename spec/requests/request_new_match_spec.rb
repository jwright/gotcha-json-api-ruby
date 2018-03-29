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
    it "returns a created status" do
      post "/api/matches", params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_created
    end
  end
end
