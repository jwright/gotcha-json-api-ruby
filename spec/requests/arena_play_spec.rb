require "request_helper"

RSpec.describe "POST /api/arenas/:id/play" do
  let(:arena) { create :arena }
  let(:player) { create :player, :authorized }
  let(:valid_parameters) { {}.to_json }

  context "with a valid request" do
    it "returns an ok status" do
      post "/api/arenas/#{arena.id}/play", params: valid_parameters,
                                           headers: valid_authed_headers

      expect(response).to be_ok
    end
  end
end
