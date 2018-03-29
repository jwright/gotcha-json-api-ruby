require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:player) { create :player, :authorized }

  subject { described_class.new(player) }

  context "for a match" do
    let(:match) { create :match }

    it "can manage a match in an arena the player is playing in" do
      player.arenas << match.arena

      expect(subject).to be_able_to :manage, match
    end

    it "can create a match" do
      expect(subject).to be_able_to :create, Match
    end

    it "cannot read a match in another arena" do
      expect(subject).to_not be_able_to :read, match
    end
  end
end
