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
    let(:player) { Player.unscoped.last }

    it "returns the correct status" do
      post "/api/players", params: parameters

      expect(response).to have_http_status(:created)
    end

    it "creates a player" do
      expect { post "/api/players", params: parameters }.to \
        change { Player.count }.by 1

      expect(player.email_address).to eq "jimmy@example.com"
    end

    xit "returns the json representation of a player"
  end

  context "with an incomplete request" do
    xit "requires the player to be valid"
  end

  context "without a correct json content type" do
    xit "returns a bad request"
  end
end
