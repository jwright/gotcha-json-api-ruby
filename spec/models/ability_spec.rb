require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:player) { create :player, :authorized }

  subject { described_class.new(player) }

  xcontext "for an arena" do
    let(:arena) { create :arena }

    it "can read an arena the player is playing in" do
      player.arenas << arena

      expect(subject).to be_able_to :read, arena
    end

    xit "cannot read an arena the player is not playing in"
    xit "cannot create an arena"
    xit "cannot update an arena"
    xit "cannot delete an arena"
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
end
