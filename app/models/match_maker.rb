class MatchMaker
  def self.match!(player:, arena:)
    return nil if player.openly_matched_in?(arena)

    opponent = Player
                .in(arena)
                .unmatched.not_already_matched_with(player, arena)
                .sample

    if opponent
      match = Match.create! seeker: player,
                            opponent: opponent,
                            arena: arena,
                            matched_at: DateTime.now
      NewMatchNotifier.new(match).notify!
      match
    end
  end
end
