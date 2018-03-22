require "rails_helper"

RSpec.describe MatchMaker do
  describe ".match!" do
    let(:arena) { create :arena }
    let!(:player_one) { create :player, arenas: [arena] }
    let!(:player_two) { create :player, arenas: [arena] }

    context "with two unmatched players in the same arena" do
      it "creates a new match between the two players" do
        match = described_class.match! player: player_two, arena: arena

        expect(match.seeker).to eq player_two
        expect(match.opponent).to eq player_one
        expect(match.arena).to eq arena
        expect(match.matched_at).to be_within(1.second).of(DateTime.now)
      end
    end

    context "with two matched players in an open match" do
      let!(:match) do
        create :match, arena: arena, seeker: player_one, opponent: player_two
      end

      it "does not create a match" do
        expect(described_class.match!(player: player_two, arena: arena)).to be_nil
      end
    end

    context "with two matched players in a previous match" do
      let!(:match) do
        create :match, :ignored, arena: arena, seeker: player_one, opponent: player_two
      end

      it "does not create a match" do
        expect(described_class.match!(player: player_two, arena: arena)).to be_nil
      end
    end

    context "with two matched players from a different arena" do
      let(:arena2) { create :arena }

      before do
        player_one.arenas << arena2
        player_two.arenas << arena2
        create :match, :found, arena: arena2, seeker: player_one, opponent: player_two
      end

      it "creates a new match between the two players" do
        match = described_class.match! player: player_two, arena: arena

        expect(match.seeker).to eq player_two
        expect(match.opponent).to eq player_one
        expect(match.arena).to eq arena
      end
    end
  end
end
