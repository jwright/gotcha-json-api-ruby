require "rails_helper"

RSpec.describe Match do
  let!(:active) { create :match }
  let!(:found) { create :match, :found }
  let!(:ignored) { create :match, :ignored }

  describe ".found" do
    it "returns all matches that were found" do
      expect(described_class.found).to match_array [found]
    end
  end

  describe ".ignored" do
    it "returns all matches that were ignored" do
      expect(described_class.ignored).to match_array [ignored]
    end
  end

  describe ".open" do
    it "returns all matches that were not found or ignored" do
      expect(described_class.open).to match_array [active]
    end
  end
end
