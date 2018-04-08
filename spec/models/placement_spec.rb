require "rails_helper"

RSpec.describe Placement do
  let(:arena) { create :arena }
  subject { described_class.new(arena) }

  describe "#scores" do
    context "for no players" do
      it "returns an empty hash" do
        expect(subject.scores).to eq({})
      end
    end

    context "for one player with no scores" do
      let!(:player) { create :player, arenas: [arena] }

      it "returns the player with 0" do
        expect(subject.scores).to eq({ player.id => 0 })
      end
    end

    context "for one player with one score" do
      let(:player) { create :player, arenas: [arena] }
      let!(:score) { create :score, arena: arena, player: player, points: 1 }

      it "returns the player with that one point" do
        expect(subject.scores).to eq({ player.id => 1 })
      end
    end

    context "for one player with multiple scores" do
      let(:player) { create :player, arenas: [arena] }
      let!(:score1) { create :score, arena: arena, player: player, points: 1 }
      let!(:score2) { create :score, arena: arena, player: player, points: 1 }

      it "returns the player with the sum of the points" do
        expect(subject.scores).to eq({ player.id => 2 })
      end
    end

    context "for three players with some scores" do
      let(:player1) { create :player, arenas: [arena] }
      let(:player2) { create :player, arenas: [arena] }
      let!(:player3) { create :player, arenas: [arena] }
      let!(:score1) { create :score, arena: arena, player: player1, points: 1 }
      let!(:score2_1) { create :score, arena: arena, player: player2, points: 1 }
      let!(:score2_2) { create :score, arena: arena, player: player2, points: 1 }

      it "returns the players with the sum of their points" do
        expect(subject.scores).to include({ player1.id => 1 })
        expect(subject.scores).to include({ player2.id => 2 })
        expect(subject.scores).to include({ player3.id => 0 })
      end

      it "orders the players from highest to lowest number of points" do
        expect(subject.scores.keys).to eq [player2.id, player1.id, player3.id]
      end
    end
  end

  describe "ordinal_for" do
    let(:player) { create :player, arenas: [arena] }

    context "for a nil score" do
      before { allow(subject).to receive(:place_for).with(player).and_return nil }

      it "returns a dash" do
        expect(subject.ordinal_for(player)).to eq "-"
      end
    end

    context "for first place" do
      before { allow(subject).to receive(:place_for).with(player).and_return 1 }

      it "returns 1st" do
        expect(subject.ordinal_for(player)).to eq "1st"
      end
    end

    context "for ninth place" do
      before { allow(subject).to receive(:place_for).with(player).and_return 9 }

      it "returns 9th" do
        expect(subject.ordinal_for(player)).to eq "9th"
      end
    end
  end

  describe "#place_for" do
    let(:player) { create :player, arenas: [arena] }

    context "with a player that is not in the arena" do
      let(:another_arena) { create :arena }
      let(:another_player) { create :player, arenas: [another_arena] }
      let!(:score) { create :score, player: another_player, arena: another_arena }

      it "returns nil" do
        expect(subject.place_for(another_player)).to be_nil
      end
    end

    context "with no scores for anyone" do
      it "returns nil" do
        expect(subject.place_for(player)).to be_nil
      end
    end

    context "with one score for one player" do
      let!(:score) { create :score, arena: arena, player: player, points: 1 }

      it "returns 1" do
        expect(subject.place_for(player)).to eq 1
      end
    end

    context "with same scores for two players" do
      let(:another_player) { create :player, arenas: [arena] }
      let!(:score1) { create :score, arena: arena, player: player, points: 1 }
      let!(:score2) { create :score, arena: arena, player: another_player, points: 1 }

      it "returns the same score for both players" do
        expect(subject.place_for(player)).to eq 1
        expect(subject.place_for(another_player)).to eq 1
      end
    end
  end
end
