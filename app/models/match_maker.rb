class MatchMaker
  def self.match!(player:, arena:)
    opponent = Player.in(arena).unmatched.not_already_matched_with(player, arena).sample

    if opponent
      match = Match.create! seeker: player,
                            opponent: opponent,
                            arena: arena,
                            matched_at: DateTime.now
      MatchNotifier.notify! match
      match
    end
  end
end