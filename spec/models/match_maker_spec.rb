require "rails_helper"

RSpec.describe MatchMaker do
  describe ".match!" do
    context "with two unmatched players in the same arena" do
      let(:arena) { create :arena }
      let!(:player_one) { create :player, arenas: [arena] }
      let!(:player_two) { create :player, arenas: [arena] }

      it "creates a new match between the two players" do
        match = described_class.match! player: player_two, arena: arena

        expect(match.seeker).to eq player_two
        expect(match.opponent).to eq player_one
        expect(match.arena).to eq arena
        expect(match.matched_at).to be_within(1.second).of(DateTime.now)
      end
    end
  end
end
