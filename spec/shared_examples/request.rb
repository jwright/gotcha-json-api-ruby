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

RSpec.shared_examples "a request requiring the correct type" do
  context "with an incorrect type specified" do
    it "returns a bad request status" do
      make_request.call({ data: { type: "blah" }}.to_json)

      expect(response).to be_bad_request
      expect(json_response[:errors]).to \
        eq ["blah is not a valid type for this operation"]
    end
  end

  context "without a type specified" do
    it "returns a bad request status" do
      make_request.call({ data: {}}.to_json)

      expect(response).to be_bad_request
      expect(json_response[:errors]).to \
        eq ["param is missing or the value is empty: type"]
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
