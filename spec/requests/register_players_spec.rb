require "rails_helper"

RSpec.describe "POST /api/players" do
  context "with a valid request" do
    let(:avatar) { "THIS NEEDS TO BE A BASE64 STRING" }
    let(:parameters) do
      {
        data: {
          type: "player",
          attributes: {
            first_name: "Jimmy",
            last_name: "Page",
            email_address: "jimmy@example.com",
            password: "p@ssword",
            avatar: avatar
          }
        }
      }
    end

    it "returns the correct status" do
      post "/api/players", params: parameters

      expect(response).to have_http_status(:created)
    end

    xit "creates a player"
    xit "returns the json representation of a player"
  end

  context "with an incomplete request" do
    xit "requires the player to be valid"
  end

  context "without a correct json content type" do
    xit "returns a bad request"
  end
end
