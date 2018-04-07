require "rails_helper"

RSpec.describe Score do
  describe ".captured_player!" do
    let(:arena) { create :arena }
    let(:player) { create :player, arenas: [arena] }

    it "creates a new score with one point" do
      score = described_class.captured_player! arena, player

      expect(score).to be_valid
      expect(score.scored_at).to be_within(1.second).of(DateTime.now)
      expect(score.arena).to eq arena
      expect(score.player).to eq player
      expect(score.points).to eq 1
    end
  end

  describe "validations" do
    subject { build :score }

    it "requires a timestamp for scored_at" do
      subject.scored_at = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:scored_at]).to include "can't be blank"
    end
  end
end
