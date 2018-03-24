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

  describe ".in" do
    let(:arena_one) { create :arena }
    let(:arena_two) { create :arena }
    let!(:match_one) { create :match, arena: arena_one }
    let!(:match_two) { create :match, arena: arena_two }

    it "returns all the matches that are assigned to the specified arena" do
      result = described_class.in(arena_one)

      expect(result).to match_array [match_one]
    end

    it "does not include matches that are not assigned to the specified arena" do
      result = described_class.in(arena_two)

      expect(result).to match_array [match_two]
    end
  end

  describe ".open" do
    it "returns all matches that were not found or ignored" do
      expect(described_class.open).to match_array [active]
    end
  end

  describe "#opponent_for" do
    let(:opponent) { create :player }
    let(:seeker) { create :player }
    let(:someone) { create :player }

    subject { create :match, seeker: seeker, opponent: opponent }

    it "returns the seeker if the opponent is passed in" do
      expect(subject.opponent_for(opponent)).to eq seeker
    end

    it "returns the opponent if the seeker is passed in" do
      expect(subject.opponent_for(seeker)).to eq opponent
    end

    it "returns nil if the player is not part of the match" do
      expect(subject.opponent_for(someone)).to be_nil
    end
  end
end
