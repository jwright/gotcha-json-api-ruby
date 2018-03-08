require "request_helper"

RSpec.describe "POST /api/sessions" do
  let(:password) { "p@ssword" }
  let(:player) { create :player, password: password }
  let(:valid_parameters) do
    {
      data: {
        type: "player",
        attributes: {
          email_address: player.email_address,
          password: password
        }
      }
    }.to_json
  end

  context "with a valid request" do
    it "returns an ok status" do
      post "/api/sessions", params: valid_parameters, headers: valid_headers

      expect(response).to be_ok
    end
  end
end
