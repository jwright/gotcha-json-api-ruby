require "rails_helper"

RSpec.describe MatchMaker do
  describe ".match!" do
    let(:arena) { create :arena }
    let!(:player_one) { create :player, arenas: [arena] }
    let!(:player_two) { create :player, arenas: [arena] }

    before { allow_any_instance_of(NewMatchNotifier).to receive(:notify!) }

    context "with two unmatched players in the same arena" do
      it "creates a new match between the two players" do
        match = described_class.match! player: player_two, arena: arena

        expect(match.seeker).to eq player_two
        expect(match.opponent).to eq player_one
        expect(match.arena).to eq arena
        expect(match.matched_at).to be_within(1.second).of(DateTime.now)
      end

      it "notifies the players of the match" do
        expect(NewMatchNotifier).to \
          receive(:new).with(an_instance_of(Match)).and_call_original
        expect_any_instance_of(NewMatchNotifier).to receive(:notify!)

        described_class.match! player: player_two, arena: arena
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

    context "with a new opponent in the same arena" do
      let!(:player_three) { create :player, arenas: [arena] }

      before do
        create :match, arena: arena, opponent: player_one, seeker: player_two
      end

      it "does not create a new match" do
        expect(described_class.match!(player: player_one, arena: arena)).to be_nil
      end
    end
  end
end
