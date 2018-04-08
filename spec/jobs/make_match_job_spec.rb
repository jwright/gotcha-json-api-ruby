require "rails_helper"

RSpec.describe MakeMatchJob do
  let(:arena) { create :arena }
  let(:match) { double(:match) }
  let(:player) { create :player, arenas: [arena] }

  it "creates a match between a player and an arena" do
    expect(MatchMaker).to \
      receive(:match!).with(player: player, arena: arena).and_return match

    described_class.perform_now player.id, arena.id
  end

  it "reschedules itself if a match was not found" do
    create :match, :ignored, arena: arena, seeker: player

    expect_any_instance_of(described_class).to \
      receive(:retry_job).with(wait: 2.minutes)

    described_class.perform_now player.id, arena.id
  end

  it "does not reschedule itself if a match exists between the player and arena" do
    allow(MatchMaker).to receive(:match!).and_return match

    expect_any_instance_of(described_class).to_not \
      receive(:retry_job)

    described_class.perform_now player.id, arena.id
  end

  it "does not create a match if the player no longer exists" do
    player_id = player.id

    player.destroy

    expect { described_class.perform_now player_id, arena.id }.to_not raise_error
  end

  it "does not create a match if the arena no longer exists" do
    player
    arena_id = arena.id

    arena.destroy

    expect { described_class.perform_now player.id, arena_id }.to_not raise_error
  end
end
