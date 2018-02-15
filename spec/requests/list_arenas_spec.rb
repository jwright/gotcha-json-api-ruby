require "rails_helper"

RSpec.describe "GET /api/arenas" do
  let(:latitude) { 39.7799642 }
  let(:longitude) { -86.2728329 }
  let(:valid_headers) do
    {
      "Accept": JSONAPI::MEDIA_TYPE,
      "Content-type": JSONAPI::MEDIA_TYPE
    }
  end
  let(:valid_parameters) do
    {
      latitude: latitude,
      longitude: longitude
    }.to_query
  end

  context "with a valid request" do
    it "returns the correct status" do
      get "/api/arenas", params: valid_parameters, headers: valid_headers

      expect(response).to be_ok
    end
  end
end
