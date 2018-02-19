require "request_helper"

RSpec.describe "GET /api/arenas" do
  let(:latitude) { 39.7799642 }
  let(:longitude) { -86.2728329 }
  let(:player) { create :player, :authorized }
  let(:valid_parameters) do
    {
      latitude: latitude,
      longitude: longitude
    }.to_query
  end

  context "with a valid request" do
    let!(:nearby_arena1) { create :arena, latitude: latitude, longitude: longitude }
    let!(:nearby_arena2) do
      create :arena,
        latitude: latitude - 0.0000001, longitude: longitude + 0.0000001
    end
    let!(:away_arena) do
      create :arena, latitude: latitude + 10, longitude: longitude - 7
    end

    it "returns an ok status" do
      get "/api/arenas", params: valid_parameters, headers: valid_authed_headers

      expect(response).to be_ok
    end

    it "returns a json representation of the arenas that are within 5 miles" do
      get "/api/arenas", params: valid_parameters, headers: valid_authed_headers

      expect(json_response[:data].length).to eq 2
      expect(json_response[:data].map { |arena| arena[:id].to_i }).to \
        match_array [nearby_arena1.id, nearby_arena2.id]
    end
  end

  it_behaves_like "an authenticated request" do
    let(:make_request) do
      -> (headers) do
        get "/api/arenas", params: valid_parameters, headers: valid_headers.merge(headers)
      end
    end
  end

  it_behaves_like "a request responding to correct headers" do
    let(:make_request) do
      -> (headers) do
        get "/api/arenas", params: valid_parameters,
                           headers: valid_authed_headers.merge(headers)
      end
    end
  end
end
