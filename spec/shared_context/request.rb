RSpec.shared_context "request" do
  let(:json_response) { JSON.parse(response.body).deep_symbolize_keys }
  let(:valid_authed_headers) do
    valid_headers.merge("Authorization": "Bearer: #{player.api_key}")
  end
  let(:valid_headers) do
    {
      "Accept": JSONAPI::MEDIA_TYPE,
      "Content-type": JSONAPI::MEDIA_TYPE
    }
  end
end
