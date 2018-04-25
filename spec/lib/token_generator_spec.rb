require "token_generator"

RSpec.describe TokenGenerator do
  describe ".generate" do
    it "generates a unique token" do
      tokens = []
      50.times do
        tokens << described_class.generate
      end

      expect(tokens.uniq.length).to eq 50
    end
  end

  describe ".generate_code" do
    it "generates a unique numeric code" do
      tokens = []
      50.times do
        tokens << described_class.generate_code(10)
      end

      expect(tokens.uniq.length).to eq 50
    end
  end
end
