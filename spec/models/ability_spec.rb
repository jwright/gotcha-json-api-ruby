require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:player) { create :player, :authorized }

  subject { described_class.new(player) }

  context "for an arena" do
    let(:arena) { create :arena }

    it "can read an arena the player is playing in" do
      player.arenas << arena

      expect(subject).to be_able_to :read, arena
    end

    it "cannot read an arena the player is not playing in" do
      expect(subject).to_not be_able_to :read, arena
    end

    it "cannot create an arena" do
      expect(subject).to_not be_able_to :create, Arena
    end

    it "cannot update an arena" do
      player.arenas << arena

      expect(subject).to_not be_able_to :update, arena
    end

    it "cannot delete an arena" do
      player.arenas << arena

      expect(subject).to_not be_able_to :delete, arena
    end
  end

  context "for a match" do
    let(:match) { create :match }

    it "can read or update a match in an arena the player is playing in" do
      player.arenas << match.arena

      expect(subject).to be_able_to :read, match
      expect(subject).to be_able_to :update, match
    end

    it "cannot delete a match in an arena the player is playing in" do
      player.arenas << match.arena

      expect(subject).to_not be_able_to :delete, match
    end

    it "can create a match" do
      expect(subject).to be_able_to :create, Match
    end

    it "cannot read a match in another arena" do
      expect(subject).to_not be_able_to :read, match
    end
  end

  context "for a player" do
    let(:someone_else) { create :player }

    it "can manage their own player" do
      expect(subject).to be_able_to :manage, player
    end

    it "can read a player they have been matched up with" do
      create :match, seeker: player, opponent: someone_else

      expect(subject).to be_able_to :read, someone_else
    end
  end

  context "for a score" do
    let(:score) { create :score }

    it "can read a score in an arena the player is playing in" do
      player.arenas << score.arena

      expect(subject).to be_able_to :read, score
    end

    it "cannot update a score in an arena the player is playing in" do
      player.arenas << score.arena

      expect(subject).to_not be_able_to :update, score
    end

    it "cannot delete a score in an arena the player is playing in" do
      player.arenas << score.arena

      expect(subject).to_not be_able_to :delete, score
    end

    it "cannot create a score" do
      expect(subject).to_not be_able_to :create, Score
    end

    it "cannot read a score in another arena" do
      expect(subject).to_not be_able_to :read, score
    end
  end
end
