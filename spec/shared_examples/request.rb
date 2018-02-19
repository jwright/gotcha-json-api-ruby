RSpec.shared_examples "a request responding to correct headers" do
  context "without a correct accept header" do
    it "returns a not acceptable status" do
      make_request.call("Accept": "application/json")

      expect(response).to have_http_status(:not_acceptable)
    end
  end

  context "without a correct content type header" do
    it "returns an unsupported media type status" do
      make_request.call("Content-type": "application/json")

      unless request.get?
        expect(response).to have_http_status(:unsupported_media_type)
      end
    end
  end
end

RSpec.shared_examples "an authenticated request" do
  context "without a valid authorization header" do
    it "returns an unauthorized request status" do
      make_request.call("Authorization": "Bearer BLAH")

      expect(response).to be_unauthorized
      expect(json_response[:errors]).to eq ["Not authorized"]
    end
  end
end
