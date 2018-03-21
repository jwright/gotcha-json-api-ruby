class MatchMaker
  def self.match!(player:, arena:)
    opponent = Player.in(arena).unmatched.not_already_matched_with(player).sample

    Match.create! seeker: player,
                  opponent: opponent,
                  arena: arena,
                  matched_at: DateTime.now
  end
end
