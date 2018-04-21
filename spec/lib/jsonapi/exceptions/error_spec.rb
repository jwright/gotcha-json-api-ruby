require "jsonapi"

RSpec.describe JSONAPI::Exceptions::Error do
  describe "#to_hash" do
    subject do
      described_class.new(code: 401,
                          detail: "You are not authorized",
                          id: "123",
                          links: [],
                          meta: {},
                          source: {},
                          status: :unauthorized,
                          title: "Not Authorized")
    end

    it "returns a hash representation of an error" do
      expect(subject.to_hash).to \
        eq({
          "code" => 401,
          "detail" => "You are not authorized",
          "id" => "123",
          "links" => [],
          "meta" => {},
          "source" => {},
          "status" => 401,
          "title" => "Not Authorized",
        })
    end
  end
end
